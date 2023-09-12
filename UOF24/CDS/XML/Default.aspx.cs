using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;

public partial class CDS_XML_Default : Ede.Uof.Utility.Page.BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {


        //<ContactList>
        //  <Contact name='A01' Phone='V01' />
        //  <Contact name='A02' Phone='V02' />
        //  <Contact name='A03' Phone='V03' />
        //<ContactList>

        XElement xe = new XElement("ContactList");

        XElement xe1 = new XElement("Contact", new XAttribute("name", "A01"), new XAttribute("Phone", "V01"));
        XElement xe2 = new XElement("Contact", new XAttribute("name", "A02"), new XAttribute("Phone", "V02"));
        XElement xe3 = new XElement("Contact", new XAttribute("name", "A03"), new XAttribute("Phone", "V03"));

        xe.Add(xe1,xe2,xe3);
        txtXML.Text = xe.ToString();
        return;
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

        XElement xe = XElement.Parse(txtXML.Text);

        var node = (from xl in xe.Elements("Contact")
                    where xl.Attribute("name").Value == txtID.Text
                    select xl).FirstOrDefault();
        txtValue.Text = node.Attribute("Phone").Value;
        return;
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(txtXML.Text);
        txtValue.Text = xmlDoc.SelectSingleNode
            ($"./FieldValue/Item[@id='{txtID.Text}']").
            Attributes["value"].Value;
        //<FieldValue>
        //  <Item id='A01' value='V01' />
        //  <Item id='A02' value='V02' >InnerText</Item>
        //  <Item id='A03' value='V03' />
        //<FieldValue>


    }
}