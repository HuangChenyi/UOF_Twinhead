using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class CDS_XML_Default : Ede.Uof.Utility.Page.BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {


        //<ContactList>
        //  <Contact name='A01' Phone='V01' />
        //  <Contact name='A02' Phone='V02' />
        //  <Contact name='A03' Phone='V03' />
        //<ContactList>

        XmlDocument xmlDoc = new XmlDocument();
        //<ContactList/>
        XmlElement ContactListElement = xmlDoc.CreateElement("ContactList");

        //  <Item id='A01' value='V01' ></Iteem>        //
        XmlElement Contact01Element = xmlDoc.CreateElement("Contact");
        Contact01Element.SetAttribute("name", "Tony");
        Contact01Element.SetAttribute("Phone", "0912345678");

        //  <Item id='A02' value='V02' >InnerText</Iteem>        //
        XmlElement Contact02Element = xmlDoc.CreateElement("Contact");
        Contact02Element.SetAttribute("name", "Wang");
        Contact02Element.SetAttribute("Phone", "0987654321");
    

        //  <Item id='A03' value='V03' ></Iteem>        //
        XmlElement Contact03Element = xmlDoc.CreateElement("Contact");
        Contact03Element.SetAttribute("name", "Mary");
        Contact03Element.SetAttribute("Phone", "0912121212");

        ContactListElement.AppendChild(Contact01Element);
        ContactListElement.AppendChild(Contact02Element);
        ContactListElement.AppendChild(Contact03Element);

        xmlDoc.AppendChild(ContactListElement);

        txtXML.Text = xmlDoc.OuterXml;



    }
    protected void btnGetValue_Click(object sender, EventArgs e)
    {
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(txtXML.Text);

        //<FieldValue>
        //  <Item id='A01' value='V01' />
        //  <Item id='A02' value='V02' >InnerText</Item>
        //  <Item id='A03' value='V03' />
        //<FieldValue>



        txtValue.Text = xmlDoc.SelectSingleNode
            ($"./FieldValue/Item[@id='{txtID.Text}']").
            Attributes["value"].Value;
    }
}