﻿using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_WebPage_MasgerPage : Ede.Uof.Utility.Page.BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblTheme.Text = this.themePath;
    }
}