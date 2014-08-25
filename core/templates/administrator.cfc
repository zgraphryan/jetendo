<cfcomponent implements="zcorerootmapping.interface.view">
<cfoutput>
<cffunction name="init" access="public" returntype="string" localmode="modern">
	<cfscript>
	application.zcore.skin.includeCSS("/z/a/stylesheets/style.css");
	</cfscript>
</cffunction>

<cffunction name="render" access="public" returntype="string" localmode="modern">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfscript>
	var tagStruct=arguments.tagStruct;
	db=request.zos.queryObject;
	</cfscript>
	<cfsavecontent variable="output">
	<cfscript>
	if(fileexists(request.zos.globals.homedir&'templates/administrator.cfc')){
		adminCom=createobject("component", request.zRootCFCPath&"templates.administrator");
		adminCom.init();
		echo(adminCom.render(tagStruct));
	}
	</cfscript>
	<cfif fileexists(request.zos.globals.homedir&'templates/administrator.cfm')><cfinclude template="#request.zrootpath#templates/administrator.cfm"></cfif>
	<cfscript>
	request.znotemplate=1;
	if(application.zcore.functions.zIsTestServer() EQ false){
		application.zcore.functions.zheader("X-UA-Compatible", "IE=edge,chrome=1");
	}
	</cfscript>#application.zcore.functions.zHTMLDoctype()#
	<head>
	    <meta charset="utf-8" />
	<title>#tagStruct.title ?: ""#</title>
	#tagStruct.stylesheets ?: ""#
	<cfscript>
	var sharedMenuStruct=0;
	var selectStruct=0;
	var secondNavHTML=tagStruct.secondnav ?: "";
	</cfscript> 
	#tagStruct.meta ?: ""#
	<script type="text/javascript">
	var zContentTransitionDisabled=true;
	</script>
	<!--[if lte IE 7]>
	<style>.zMenuBarDiv ul a {height: 1%;}</style>
	<![endif]-->
	<!--[if lte IE 6]>
	<style>.zMenuBarDiv li ul{width:1% !important; white-space:nowrap !important;}
	</style>
	<![endif]-->
	
	</head>
	<body>
	<!--- 
	A major system update is in progress. Please try again later.</body></html><cfscript>application.zcore.functions.zabort();</cfscript>
	 ---> 
	<cfscript>
	if(structkeyexists(request.zsession.user, 'group_id')){
		userGroupId=request.zsession.user.group_id;
	}else{
		userGroupId=0;
	}
	</cfscript>
	<cfif not request.zos.inServerManager and (application.zcore.functions.zso(form, 'zreset') NEQ 'template' and 
	structkeyexists(application.siteStruct[request.zos.site_id].administratorTemplateMenuCache, request.zsession.user.site_id&"_"&request.zsession.user.id))>
		#application.siteStruct[request.zos.site_id].administratorTemplateMenuCache[request.zsession.user.site_id&"_"&request.zsession.user.id]#
	<cfelse>
		<cfsavecontent variable="templateMenuOutput">
			<cfscript>
			ws=application.zcore.app.getWhitelabelStruct();
			</cfscript>
			<style type="text/css">
			.zDashboardContainerPad{width:97%; padding:1.5%; float:left;}
			.zDashboardContainer{width:100%; }
			.zDashboardHeader{width:98%; padding:1%; float:left;}
			.zDashboardMainContainer{width:100%; float:left;}
			<cfif ws.whitelabel_dashboard_sidebar_html NEQ "">
				.zDashboardMain{max-width:67%; padding:1%; width:100%; float:left;}
				.zDashboardSidebar{ margin-left:2%; padding:1%; width:26%; float:left; }
			<cfelse>
				.zDashboardMain{ width:98%; padding:1%; float:left;}
			</cfif>
			.zdashboard-header-image320 img{float:left;}
			.zdashboard-header-image640 img{float:left;}
			.zdashboard-header-image960 img{float:left;}
			.zdashboard-header-image320{float:left; width:100%;background-color:###ws.whitelabel_dashboard_header_background_color#;  display:none;}
			.zdashboard-header-image640{float:left; width:100%;background-color:###ws.whitelabel_dashboard_header_background_color#; display:none;}
			.zdashboard-header-image960{float:left; width:100%;background-color:###ws.whitelabel_dashboard_header_background_color#; display:block;}
			
			.zDashboardFooter{width:98%; padding:1%;  float:left;}
			.zDashboardButton:link, .zDashboardButton:visited{ width:150px;text-decoration:none; color:##000;padding:1%;display:block; border:1px solid ##CCC; margin-right:2%; margin-bottom:2%; background-color:##F3F3F3; border-radius:10px; text-align:center; float:left; }
			.zDashboardButton:hover{background-color:##FFF; border:1px solid ##666;display:block; color:##666;}
			.zDashboardButtonImage{width:100%; height:64px; float:left;margin-bottom:5px;display:block;}
			.zDashboardButtonTitle{width:100%; float:left;margin-bottom:5px; font-size:115%; display:block;font-weight:bold;}
			.zDashboardButtonSummary{width:100%; float:left;}

			@media only screen and (max-width: 980px) { 
				.zDashboardContainer{width:100%;}
				<cfif ws.whitelabel_dashboard_sidebar_html NEQ ""> 
				</cfif>
			}

			@media only screen and (max-width: 660px) { 
				.zdashboard-header-image960{display:none;}
				.zdashboard-header-image640{display:block;}
				.zDashboardContainer{width:100%;}
				.zDashboardMain{max-width:100%;width:98%;}
				.zDashboardSidebar{margin-left:0px; width:98%; float:left;}

			}
			@media only screen and (max-width: 340px) { 
				.zdashboard-header-image960{display:none;}
				.zdashboard-header-image640{display:none;}
				.zdashboard-header-image320{display:block;}
			}
			#ws.whitelabel_css#
			</style>
			<cfif ws.whitelabel_dashboard_header_image_320 NEQ "">
	
				<div class="zdashboard-header-image320" style="background-color:###ws.whitelabel_dashboard_header_background_color#;"><img src="#ws.imagePath##ws.whitelabel_dashboard_header_image_320#" style="width:100%; " alt="Site Manager"></div>
				<div class="zdashboard-header-image640" style="background-color:###ws.whitelabel_dashboard_header_background_color#;"><img src="#ws.imagePath##ws.whitelabel_dashboard_header_image_640#" style="width:100%; " alt="Site Manager"></div>
				<div class="zdashboard-header-image960" style="background-color:###ws.whitelabel_dashboard_header_background_color#;"><img src="#ws.imagePath##ws.whitelabel_dashboard_header_image_960#" style="max-width:100%; " alt="Site Manager"></div>
			</cfif>
	
			<div style="width:100%; float:left; border-bottom:1px solid ##999; background: ##1e5799; /* Old browsers */
background: -moz-linear-gradient(top,  ##1e5799 0%, ##2989d8 94%, ##7db9e8 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,##1e5799), color-stop(94%,##2989d8), color-stop(100%,##7db9e8)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  ##1e5799 0%,##2989d8 94%,##7db9e8 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  ##1e5799 0%,##2989d8 94%,##7db9e8 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  ##1e5799 0%,##2989d8 94%,##7db9e8 100%); /* IE10+ */
background: linear-gradient(to bottom,  ##1e5799 0%,##2989d8 94%,##7db9e8 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='##1e5799', endColorstr='##7db9e8',GradientType=0 ); /* IE6-9 */
">
				<div style="min-width:200px; width:46%; color:##FFF; padding:0.5%; float:left;">
					<cfif request.zos.inServerManager>
						<a href="/z/admin/admin-home/index" style="text-decoration:none; color:##FFFFFF;">Return to Site Manager</a>
					<cfelse>
						<div style="width:99%; font-size:120%; padding:0.5%; float:left;">
							#request.zos.globals.sitename#
						 </div>
						<div style="width:99%; padding:0.5%; float:left;">
							Site Manager | <a href="/" target="_blank" style="color:##FFF;">View Home Page</a>
						</div>
					
					 </cfif>
				</div>
				<div style="min-width:200px; width:50%; padding:0.5%; text-align:right;float:right;">

					<div style="width:70px; float:right;" class="zapp-shell-logout">
					<a href="/z/admin/admin-home/index?zlogout=1">Log Off</a>
					</div>
					<div style="width:130px;padding-top:10px; float:right;">
					<cfscript>
					if(request.zos.isDeveloper and request.zsession.user.site_id EQ request.zos.globals.serverId and application.zcore.user.checkServerAccess()){
						siteIdSQL=" and site_id <> -1";
					}else{
						if(request.zsession.user.site_id NEQ request.zos.globals.id and application.zcore.user.checkGroupAccess("administrator")){
							if(request.zos.globals.parentID NEQ 0){
								siteIdSQL=" and (site_id = '"&request.zos.globals.parentID&"' or site_parent_id ='"&request.zos.globals.parentID&"')";
							}else{
								siteIdSQL=" and (site_id = '"&request.zos.globals.id&"' or site_parent_id ='"&request.zos.globals.id&"')";
							}
						}else{
							db.sql="select * from #db.table("user", request.zos.zcoreDatasource)# user 
							WHERE user_id=#db.param(request.zsession.user.id)# and 
							site_id=#db.param(request.zsession.user.site_id)# and
							user_deleted = #db.param(0)#";
							qUser=db.execute("qUser");
							
							arrSiteId=listtoarray(qUser.user_sync_site_id_list, ",",false);
							arrayappend(arrSiteId, request.zsession.user.site_id);
							siteIdSQL=" and site_id IN ('"&arraytolist(arrSiteId, "','")&"')";
						}
					}
					db.sql="select replace(replace(site_short_domain, #db.param('www.')#, #db.param('')#), #db.param('.#request.zos.testDomain#')#,#db.param('')#) shortDomain, 
					site_domain 
					from #db.table("site", request.zos.zcoreDatasource)# site
					WHERE site_active=#db.param(1)# "&db.trustedSQL(siteIdSQL)&" and 
					site_id <> #db.param(request.zos.globals.id)# and 
					site_deleted = #db.param(0)# ";
					if(not application.zcore.user.checkAllCompanyAccess()){
						db.sql&=" and company_id = #db.param(request.zsession.user.company_id)#";
					}
					db.sql&=" order by shortDomain asc";
					qSite=db.execute("qSite");
					if(qSite.recordcount NEQ 0){
						selectStruct = StructNew();
						selectStruct.name = "changeSiteID";
						selectStruct.query = qSite;
						selectStruct.inlineStyle="width:120px;";
						selectStruct.selectLabel="-- Change Site --";
						selectStruct.onchange="var d1=this.options[this.selectedIndex].value;if(d1 !=''){window.location.href=d1+'/member/';}";
						selectStruct.queryLabelField = "shortDomain";
						selectStruct.queryValueField = "site_domain";
						application.zcore.functions.zInputSelectBox(selectStruct);
					}
					</cfscript>
					</div>
				</div>
			</div>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="table-list" style="margin-bottom:10px; ">
	<!--- <tr>
	<td style="font-size:18px;line-height:normal;padding:10px;background-color:##336699; color:##DFDFDF; width:654px;">
		<cfif request.zos.inServerManager>
		<a href="/z/admin/admin-home/index" style="text-decoration:none; color:##FFFFFF;">Return to Site Manager</a>
		<cfelse>
		<a href="/" target="_blank" style="text-decoration:none; color:##FFFFFF;">#request.zos.globals.sitename#</a>
		 | Site Manager
		 </cfif>
		</td>
	<td style="text-align:right;background-color:##336699; color:##DFDFDF;width:400px; padding-right:5px;">
	</td>
	    <td class="zapp-shell-logout" style="padding:0px;width:70px;"><a href="/z/admin/admin-home/index?zlogout=1">Log Off</a></td>
	    </tr> --->
		<cfif not request.zos.inServerManager>
	    <tr><td colspan="3" class="zapp-admin-nav-text2" style="padding:0px;border-top:1px solid ##CCCCCC;">
	
		<cfscript>
		sharedMenuStruct=structnew();
		
		sharedMenuStruct=application.zcore.app.getAdminMenu(sharedMenuStruct); 
		if(application.zcore.app.siteHasApp("content") EQ false){
			if(structkeyexists(sharedMenuStruct,"Files &amp; Images") EQ false){
				ts=structnew();
				ts.featureName="Files & Images";
				ts.link="/z/admin/files/index";  
				ts.children=structnew();
				sharedMenuStruct["Files &amp; Images"]=ts;
			}
			if(structkeyexists(sharedMenuStruct,"Site Options") EQ false){
				ts=structnew();
				ts.featureName="Site Options";
				ts.link="/z/admin/site-options/index";
				ts.children=structnew();
				sharedMenuStruct["Site Options"]=ts;
			}
		}
		// remove links to the old system
		tmp=application.zcore.functions.zso(request, 'adminTemplateLinks');
		if(trim(tmp) NEQ ""){
			tmp='<li>'&rereplacenocase(tmp,'</a>(.*?)<a','</a></li> <li><a','ALL')&'</li>';
		}
		tmp=replacenocase(tmp,'<a ','<a class="trigger" ','ALL');
		if(application.zcore.app.siteHasApp("content")){
			tmp=replacenocase(tmp,">content<",' style="display:none;"><');
		}
		if(application.zcore.app.siteHasApp('listing')){
			tmp=replacenocase(tmp,">inquiries<",' style="display:none;"><');
			tmp=replacenocase(tmp,">saved searches<",' style="display:none;"><');
			tmp=replacenocase(tmp,">manage leads<",' style="display:none;"><');
		}
		application.zcore.app.outputAdminMenu(sharedMenuStruct, tmp);
	  </cfscript>
	</td>
	</tr>
	</cfif>
	</table>
	</cfsavecontent>
	    #templateMenuOutput#
		<cfif not request.zos.inServerManager>
			<cfset application.siteStruct[request.zos.site_id].administratorTemplateMenuCache[request.zsession.user.site_id&"_"&request.zsession.user.id]=templateMenuOutput>
		</cfif>
	</cfif>
	<cfif request.zos.inServerManager>
	#secondNavHTML#
	</cfif>
	<div class="zapp-shell-container">
	
	
	
	<cfif application.zcore.functions.zso(request, 'adminTemplateContent') NEQ "">
	  #application.zcore.functions.zso(request, 'adminTemplateContent')#<hr />
	  </cfif>
	  #tagStruct.pagenav ?: ""#
	  <cfif application.zcore.template.getTagContent("pagetitle") NEQ "">
	  <h1>#tagStruct.pagetitle ?: ""#</h1>
	  </cfif>
	   #tagStruct.content ?: ""#
	  <div class="zapp-shell-foot"><hr />Copyright&copy; #year(now())# <a href="/">#request.zos.globals.shortdomain#</a>. All Rights Reserved.
	  </div>
	  </div>
	<script type="text/javascript">
	/* <![CDATA[ */ 
	  WebFontConfig = {
	    google: { families: [ 'Open+Sans:400italic,700italic,400,700:latin' ] }
	  };
	  (function() {
	    var wf = document.createElement('script');
	    wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
	      '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
	    wf.type = 'text/javascript';
	    wf.async = 'true';
	    var s = document.getElementsByTagName('script')[0];
	    s.parentNode.insertBefore(wf, s);
	  })(); 
	  var zDisableBackButton=false; 
	  
	function backButtonOverrideBody()
	{
		if(zDisableBackButton==false) return;
	  try {
	    history.forward();
	  } catch (e) {
	  }
	  setTimeout("backButtonOverrideBody()", 500);
	}
	zArrDeferredFunctions.push(function(){backButtonOverrideBody();});
	 /* ]]> */
	 </script>
	#tagStruct.scripts ?: ""#
	<!--- #(gettickcount()-s)/1000# seconds --->
	</body>
	</html>
	</cfsavecontent>
	<cfreturn output>
</cffunction>
</cfoutput>
</cfcomponent>