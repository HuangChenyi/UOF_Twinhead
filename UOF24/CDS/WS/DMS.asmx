<%@ WebService Language="C#" Class="DMS" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Xml;
using System.Collections;
using Ede.Uof.DMS;
using Ede.Uof.DMS.Data;
using Ede.Uof.DMS.Query;
using Ede.Uof.DMS.DocStore;
using Ede.Uof.DMS.PlugIn;
using System.Text.RegularExpressions;
using Ede.Uof.Utility.FileCenter.V3;
using Ede.Uof.DMS.Exceptions;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.Utility.Configuration;
using System.Web.Helpers;
using System.Collections.Generic;
using System.IO;
using Ede.Uof.WKF.Data;
using Ede.Uof.WKF.Engine;
using Ede.Uof.WKF.Utility;
using System.Xml.Linq;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
public class DMS  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    /// <summary>
    /// 檢查在 Folder 之中, 是否有 Document Name 重覆,
    /// 用於在上傳之前的檢查
    /// </summary>
    /// <param name="token"></param>
    /// <param name="folderId"></param>
    /// <param name="docName"></param>
    /// <returns></returns>
    public bool GetDocNameDuplicate(string userGuid, string folderId, string docName)
    {
        //========= 從認證 Token 取得 USER_GUID ========
   
        //try
        //{
        //    userGuid = m_webserviceAuth.GetUserGuidFromToken(token);
        //}
        //catch { }

        //if (userGuid == null)
        //{
        //    throw new Exception("[Dms] GetDocNameDuplicate() : Token is invalid, please check your authentication !");
        //}

        DefaultUCO uco = new DefaultUCO();
        DMSDocDS ds = uco.GetFolderAllDocument(folderId, "", userGuid, "");

        // 應取得 docDS.TBDocProperty
        for (int i = 0; i < ds.TBDocProperty.Rows.Count; i++)
        {
            DMSDocDS.TBDocPropertyRow row = ds.TBDocProperty[i];
            if (row["DOC_NAME"].ToString() == docName)
            {
                return true;
            }
        }

        return false;
    }


    /// <summary>
    /// 取得 Folder 的審核參數
    /// 返回值 :
    /// returnValue[0] = appParentID;    (最上層的審核代碼)        
    /// returnValue[1] = ApproveRmID;    (權限代碼)
    /// returnValue[2] = needApprove;    (true 或 false)
    /// returnValue[3] = APPROVE_TYPE;   (WKF or DMS)
    /// </summary>
    /// <param name="folderId"></param>
    /// <param name="containSelf"></param>
    /// <returns></returns>
    private string[] GetApproveRM(string folderId, bool containSelf)
    {
        string[] approveValue;
        ApproveUCO approve = new ApproveUCO();
        approveValue = approve.GetApproveRM(folderId, true);

        return approveValue;
    }

    private void InitialAuthentication(string userGuid)
    {
        UserUCO ucoCheckuser = new UserUCO();

        //取得 user 的 guid 存入 FormsAuthentication中;
        EBUser ebUser = ucoCheckuser.GetEBUser(userGuid);
        Setting setting = new Setting();
        int userTimeOut = int.Parse(setting["UserTimeOut"]);

        string currentCurrent = ebUser.Culture;

        System.Web.Security.FormsAuthenticationTicket ticket;
        ticket = new System.Web.Security.FormsAuthenticationTicket(1,
                                               userGuid,
                                               DateTime.Now,
                                               DateTime.Now.AddMinutes(userTimeOut),
                                               false,
                                               string.Format(
                                                   "Culture={0}|Theme={1}|Name={2}|Account={3}|UserType={4}"
                                                   , currentCurrent
                                                   , ebUser.Theme
                                                   , ebUser.DisplayName
                                                   , ebUser.Account
                                                   , ebUser.UserType.ToString()
                                                   ),
                                               System.Web.Security.FormsAuthentication.FormsCookiePath);




        // 建立 Identity 物件
        System.Web.Security.FormsIdentity id = new System.Web.Security.FormsIdentity(ticket);

        // 建立 GenericPrincipal 物件, 儲存到 HttpContext 中
        string[] roles = new string[0];
        System.Security.Principal.GenericPrincipal principal = new System.Security.Principal.GenericPrincipal(id, roles);

        Context.User = principal;
    }

    /// <summary>
    /// 取得目錄的發佈條件, 只要有任一個條件成立, 就不能使用 WebService 執行上傳
    /// </summary>
    /// <param name="token"></param>
    /// <param name="folderId"></param>
    /// <returns></returns>

    public string[] GetFolderLimit(
        string token,
        string folderId)
    {
        //========= 從認證 Token 取得 USER_GUID ========
        string userGuid = null;
        try
        {
            userGuid = m_webserviceAuth.GetUserGuidFromToken(token);
        }
        catch { }

        if (userGuid == null)
        {
            throw new Exception("[Dms] GetFolderLimit() : Token is invalid, please check your authentication !");
        }

        // 取出 Folder 的檢查項目, 如果有一項就不支援批次上傳後發佈
        ArrayList al = new ArrayList();

        // 檢查 Folder Publish 的限制
        DMSPropertyLimit dmsProLim = new DMSPropertyLimit(folderId, true);

        // 是否輸入文件編號
        if (dmsProLim.IsLimDocSerial)
        {
            al.Add("IsLimDocSerial");
        }

        //是否有限制發行單位的輸入
        if (dmsProLim.IsLimPublishUnit)
        {
            al.Add("IsLimPublishUnit");
        }

        //是否有限制保管者的輸入
        if (dmsProLim.IsLimCustodyUser)
        {
            al.Add("IsLimCustodyUser");
        }

        //是否有限制摘要的輸入
        if (dmsProLim.IsLimDocComment)
        {
            al.Add("IsLimDocComment");
        }

        //是否有限制關鍵字的輸入
        if (dmsProLim.IsLimDocKeyword)
        {
            al.Add("IsLimDocKeyword");
        }

        //是否有限制文件類別的輸入
        if (dmsProLim.IsLimDocType)
        {
            al.Add("IsLimDocType");
        }

        // 是否需要輸入參考文件
        if (dmsProLim.IsLimDocReflink)
        {
            al.Add("IsLimDocReflink");
        }

        // 檢查審核方式, 如果使用 WKF 簽核, 就不能發佈
        string[] approveStrs = GetApproveRM(folderId, true);
        if (approveStrs[2] == "true" && approveStrs[3] == "WKF")
        {
            al.Add("ApproveTypeIsWKF");
        }

        // 檢查身分, 如果是讀者, 或是無權限, 則無法上傳
        if (true)
        {
            DMSFolder dmsFolderprv = new DMSFolder();
            DMSAuthority folderAuthority = dmsFolderprv.GetFolderPrivilege(folderId, userGuid);

            if (folderAuthority == DMSAuthority.DMSNone ||
                folderAuthority == DMSAuthority.DMSReader)
            {
                al.Add("WithoutWritePermission");
            }
        }


        //// 檢查是否 PDF 轉換, 如果有就不能上傳     
        //if (true)
        //{
        //    Setting setting = new Setting();
        //    DMSFolder dmsFolder = new DMSFolder();
        //    FolderDS.TBFolderSourceControlRow folderRow = dmsFolder.GetFolderSourceControl(folderId, true);

        //    if (setting["DMSPDF"].ToLower() != "false" && folderRow.CONVERT_PDF == true)
        //    {
        //        al.Add("NeedConvertToPDF");
        //    }
        //}                       

        // 準備返回值
        string[] strs = new string[al.Count];
        for (int i = 0; i < al.Count; i++)
        {
            strs[i] = al[i].ToString();
        }

        return strs;
    }


    Ede.Uof.EIP.Security.WebService.Authentication m_webserviceAuth = new Ede.Uof.EIP.Security.WebService.Authentication();

    /// <summary>
    /// 寫入檔案資料到文管 (要先將檔案上傳)
    /// 需先使用 GetFolderLimit() 檢查目錄是否有檔案限制,
    /// 與 IsDocNameDuplicate() 檢查是否有重複檔名
    /// </summary>
    /// <param name="token"></param>
    /// <param name="folderId"></param>
    /// <param name="docName"></param>
    /// <param name="fileName"></param>
    /// <param name="isPublish"></param>
    /// <param name="fileGroupId"></param>
    /// <param name="keyword"></param>
    /// <param name="DOC_SERIAL"></param>
    /// <param name="docClass"></param>
    /// <param name="DOC_COMMENT"></param>
    /// <param name="account"></param>
    /// <returns></returns>
    [WebMethod]
    public string AddNewDoc(string token,
        string folderId,
        string docName,
        string fileName,
        bool isPublish,
        string fileGroupId,
        string keyword,
        string DOC_SERIAL,
        string docClass,
        string DOC_COMMENT,
        string account,
        string version,
        string PUBLISH_UNIT)
    {

        try
        {
            //========= 從認證 Token 取得 USER_GUID ========
            string userGuid = null;
            //try
            //{

            //    userGuid = m_webserviceAuth.GetUserGuidFromToken(token);
            //}
            //catch { }

            //if (userGuid == null)
            //{
            //    throw new Exception("[Dms] AddNewDoc() : Token is invalid, please check your authentication !");
            //}

            userGuid = new UserUCO().GetGUID(account);

            // 初始化 Ede.Uof.EIP.SystemInfo.Current 物件, 解決呼叫到 Web 高相依性的 UCO 問題
            this.InitialAuthentication(userGuid);

            // 建立 UCO
            FolderDS folderDS = new FolderDS();
            DMSFolder dmsFolder = new DMSFolder();
            DMSDoc dmsDOC = new DMSDoc();

            // 取得發佈參數
            string[] approveStrs = GetApproveRM(folderId, true);

            // 檢查目錄是否可以上傳
            //if (true)
            //{
            //    string[] limitStrs = GetFolderLimit(token, folderId);   // 取出目錄的限制
            //    if (limitStrs.Length > 0)
            //    {
            //        string errorStr = String.Format("[Dms] AddNewDoc() : Folder not support upload for WebService, reason : {0}",
            //            String.Join(",", limitStrs));
            //        throw new Exception(errorStr);
            //    }
            //}

            // 檢查文件名稱是否重覆
            if (true)
            {
                if (GetDocNameDuplicate(userGuid, folderId, docName))
                {
                    string errorStr = String.Format("[Dms] AddNewDoc() : DocName [{0}] is duplicate at the same folder !", docName);
                    throw new Exception(errorStr);
                }
            }

            //========== 設定 DocProperty 屬性 =========
            AddNewDocUCO addUCO = new AddNewDocUCO();
            DMSDocDS docDS = new DMSDocDS();

            DMSDocDS.TBDocPropertyRow docr = docDS.TBDocProperty.NewTBDocPropertyRow();
            DMSDocDS.TB_DMS_LENDRow LendROW = docDS.TB_DMS_LEND.NewTB_DMS_LENDRow();

            docr.FOLDER_ID = folderId;      //目錄ID
            docr.DOC_ID = System.Guid.NewGuid().ToString();               //文件ID
            docr.DOC_SERIAL = DOC_SERIAL;           //文件編號
            docr.DOC_AUTHOR = userGuid;     //作者

            // 文件是存回還是公怖
            if (isPublish)
            {
                docr.DOC_STATUS = DocStatus.Publish.ToString(); // 公佈
            }
            else
            {
                docr.DOC_STATUS = DocStatus.CheckIn.ToString(); // 存回   
            }

            // 電子檔
            docr.DOC_TYPE = "file";

            // 版本控制
            docr.VER_MANUAL_CONTROL = false;    // 自動設定版本

            docr.VERSION_COMMENT = "";

            // 版本手動控制序號
            if (isPublish)
            {
                docr.MANUAL_VERSION = version;
            }
            else
            {
                docr.MANUAL_VERSION = "0.1";
            }

            // 發行單位
            docr.PUBLISH_UNIT = PUBLISH_UNIT;

            // 保管者
            docr.CUSTODY_USER = "<UserSet />";

            // 文件備註
            docr.DOC_COMMENT = DOC_COMMENT;


            DateTime miniValue = new DateTime(1911, 1, 1);
            DateTime maxValue = new DateTime(9999, 12, 31);

            docr.DOC_KEYWORD = keyword;  //關鍵字


            // 保存期限
            // 生效日 (立刻生效)        DateTimeOffset
            DateTimeOffset offsetMiniValue = new DateTimeOffset(miniValue);
            docr.ACTIVE_DAY = offsetMiniValue;
            docr.ACTIVE_STATUS = "Active";

            // 失效日 (永不過期)
            DateTimeOffset offsetMaxValue = new DateTimeOffset(maxValue);
            docr.INVALID_DAY = offsetMaxValue;

            //============= 設定機密資訊 =============                           
            // 取得機密資訊    
            FolderDS.TBFolderSourceControlRow folderRow = dmsFolder.GetFolderSourceControl(folderId, true);

            docr.SECRET_RANK = folderRow.SECRET_RANK;   // 機密設定          
            docr.COMMON_EDIT = folderRow.AUTH_COMMON_EDIT;    // 設定共同編輯

            //不轉成PDF
            docr.SOURCE_CONTROL = "Source";
            docr.SECRET_DEFINE = false;

            //調閱設定            
            LendROW.INHERIT_PARENT = true;
            LendROW.DOC_ID = docr.DOC_ID;

            // 文件類別 多筆就用;去隔
            docr.DOC_CLASS = docClass;

            // 檔案屬性
            docr.FILE_ID = fileGroupId;
            docr.DOC_NAME = docName;

            DateTimeOffset now = UserTime.SetZone(userGuid).GetNowForDb();
            //修改日
            docr.MODIFY_DATE = now;
            //公佈日
            docr.PUBLISH_DATE = now;

            docr.IS_ACTIVE_EQUALTO_PUBLISH = false;

            docr.IS_USE_ARTICLE = true;

            docr.ATTACH_CONVERT_PDF = false;

            //=========== 將資料寫入 DB ===========
            docDS.TBDocProperty.Rows.Add(docr);
            docDS.TB_DMS_LEND.Rows.Add(LendROW);

            string taskIdStr = "";
            string rmIdStr = approveStrs[1];
            bool needApproveBool = Convert.ToBoolean(approveStrs[2]);

            addUCO.AddDOC(docDS, taskIdStr, rmIdStr, needApproveBool, userGuid);

            // 將檔案設定為永久保存                   
            FileGroup fg = FileCenter.GetFileGroup(fileGroupId);
            if (fg != null)
                fg.SubmitChanges(userGuid);
            return ""; // 返回 DOC_ID
        }
        catch(Exception ce)
        {
            return ce.ToString();
        }

    }


}