using Ede.Uof.Utility.Configuration;
using Ede.Uof.Utility.FileCenter.V3;
using Ede.Uof.WKF.ExternalUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Training.Trigger.DocForm
{
    public class EndFormTrigger : ICallbackTriggerPlugin
    {
        public void Finally()
        {
          //  throw new NotImplementedException();
        }

        public string GetFormResult(ApplyTask applyTask)
        {
            //<Form formVersionId="2afea512-b465-494c-b46c-9847e8157a4d">
            //  <Applicant userGuid="f693e452-5ef8-47b2-ad17-92bfdba743bc" account="Wang" name="Wang" />
            //  <FormFieldValue>
            //    <FieldItem fieldId="NO" fieldValue="BPM230900002" realValue="" enableSearch="True" />
            //    <FieldItem fieldId="A01" fieldValue="Tony(Tony)" realValue="&lt;UserSet&gt;&lt;Element type='user'&gt; &lt;userId&gt;c496e32b-0968-4de5-95fc-acf7e5a561c0&lt;/userId&gt;&lt;/Element&gt;&lt;/UserSet&gt;&#xD;&#xA;" enableSearch="True" />
            //    <FieldItem fieldId="A03" fieldValue="A00002" realValue="" enableSearch="True" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
            //    <FieldItem fieldId="A04" fieldValue="1.4" realValue="" enableSearch="True" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
            //    <FieldItem fieldId="A05" fieldValue="1.4444" realValue="" enableSearch="True" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
            //    <FieldItem fieldId="A02" fieldValue="f125e1d1-17fe-4876-bde3-59bff68623fe" realValue="" enableSearch="True" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
            //    <FieldItem fieldId="A06" 
			         //      fieldValue="秘書室" 
			         //      realValue="&lt;UserSet&gt;&lt;Element type='group' isDepth='False'&gt;&lt;groupId&gt;9a8731c9-fdab-8ed2-3e54-3eca2b38f74b&lt;/groupId&gt;&lt;/Element&gt;&lt;/UserSet&gt;&#xD;&#xA;" enableSearch="True" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
            //  </FormFieldValue>
            //</Form>


            if(applyTask.FormResult == Ede.Uof.WKF.Engine.ApplyResult.Adopt)
            {
                var fields = applyTask.Task.CurrentDocument.Fields;
               
                var newfileGroupId= FileCenter.Clone(fields["A02"].FieldValue, Module.DMS,"DMS_SOURCE");
                FileGroup fg = FileCenter.GetFileGroup(newfileGroupId);
                Setting setting = new Setting();
                DMS.DMS dms = new DMS.DMS();
                dms.Url = setting["SiteUrl"] + "/CDS/WS/DMS.asmx";
                var result= dms.AddNewDoc("", "f380dc0b-0daf-448b-9d4c-29f92d981ec0",
                   fields["A05"].FieldValue, fg[0].Name
                   , true, newfileGroupId, "", fields["A03"].FieldValue, "", "",
                   applyTask.Task.Applicant.Account, fields["A04"].FieldValue,
                   fields["A06"].RealValue
                   );
                // CALL API TO DMS

                if(result != "")
                {
                    throw new Exception(result);
                }
            }
            return "";
          //  throw new NotImplementedException();
        }

        public void OnError(Exception errorException)
        {
            //throw new NotImplementedException();
        }
    }
}
