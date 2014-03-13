<cfcomponent implements="zcorerootmapping.interface.siteOptionType">
<cfoutput>
<cffunction name="getSearchFieldName" localmode="modern" access="public" returntype="string" output="no">
	<cfargument name="setTableName" type="string" required="yes">
	<cfargument name="groupTableName" type="string" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfscript>
	return arguments.groupTableName&".site_x_option_group_value";
	</cfscript>
</cffunction>
<cffunction name="onBeforeImport" localmode="modern" access="public">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfscript>
	return { mapData: false, struct: {} };
	</cfscript>
</cffunction>

<cffunction name="getSortSQL" localmode="modern" access="public" returntype="string" output="no">
	<cfargument name="fieldIndex" type="string" required="yes">
	<cfargument name="sortDirection" type="string" required="yes">
	<cfscript>
	return "sVal"&arguments.fieldIndex&" "&arguments.sortDirection;
	</cfscript>
</cffunction>

<cffunction name="isSearchable" localmode="modern" access="public" returntype="boolean" output="no">
	<cfscript>
	return false;
	</cfscript>
</cffunction>

<cffunction name="getSearchFormField" localmode="modern" access="public"> 
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfargument name="prefixString" type="string" required="yes">
	<cfargument name="dataStruct" type="struct" required="yes"> 
	<cfargument name="value" type="string" required="yes">
	<cfargument name="onChangeJavascript" type="string" required="yes">
	<cfscript>
	return '<input type="text" name="#arguments.prefixString##arguments.row.site_option_id#" onkeyup="#arguments.onChangeJavascript#" onpaste="#arguments.onChangeJavascript#" id="#arguments.prefixString##arguments.row.site_option_id#" value="#htmleditformat(arguments.value)#" size="8" />';
	</cfscript>
</cffunction>


<cffunction name="getSearchValue" localmode="modern" access="public">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfargument name="prefixString" type="string" required="yes"> 
	<cfargument name="dataStruct" type="struct" required="yes">
	<cfargument name="searchStruct" type="struct" required="yes">
	<cfscript>
	return arguments.dataStruct[arguments.prefixString&arguments.row.site_option_id];
	</cfscript>
</cffunction>

<cffunction name="getSearchSQLStruct" localmode="modern" access="public">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfargument name="prefixString" type="string" required="yes"> 
	<cfargument name="dataStruct" type="struct" required="yes">
	<cfargument name="value" type="string" required="yes">
	<cfscript>
	ts={
		type="=",
		field: arguments.row.site_option_name,
		arrValue:[]
	};
	if(arguments.value NEQ ""){
		arrayAppend(ts.arrValue, arguments.dataStruct[arguments.prefixString&arguments.row.site_option_id]);
	}
	return ts;
	</cfscript>
</cffunction>

<cffunction name="getSearchSQL" localmode="modern" access="public">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfargument name="prefixString" type="string" required="yes"> 
	<cfargument name="dataStruct" type="struct" required="yes">
	<cfargument name="databaseField" type="string" required="yes">
	<cfargument name="databaseDateField" type="string" required="yes">
	<cfargument name="value" type="string" required="yes">
	<cfscript>
	var db=request.zos.queryObject;
	if(arguments.value NEQ ""){
		return arguments.databaseField&' like '&db.trustedSQL("'%"&application.zcore.functions.zescape(arguments.dataStruct[arguments.prefixString&arguments.row.site_option_id])&"%'");
	}
	return '';
	</cfscript>
</cffunction>

<cffunction name="validateFormField" localmode="modern" access="public">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfargument name="prefixString" type="string" required="yes">
	<cfargument name="dataStruct" type="struct" required="yes">
	<cfscript>
	/*
	var nv=application.zcore.functions.zso(arguments.dataStruct, arguments.prefixString&arguments.row.site_option_id);
	if(nv NEQ "" and doValidation...){
		return { success:false, message: arguments.row.site_option_display_name&" must ..." };
	}
	*/
	return {success:true};
	</cfscript>
</cffunction>

<cffunction name="hasCustomDelete" localmode="modern" access="public" returntype="boolean" output="no">
	<cfscript>
	return false;
	</cfscript>
</cffunction>

<cffunction name="onDelete" localmode="modern" access="public" output="no">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfscript>
	</cfscript>
</cffunction>

<cffunction name="getFormField" localmode="modern" access="public">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfargument name="prefixString" type="string" required="yes">
	<cfargument name="dataStruct" type="struct" required="yes"> 
	<cfargument name="labelStruct" type="struct" required="yes"> 
	<cfscript>
	arrGroup=listToArray(application.zcore.functions.zso(arguments.optionStruct, 'user_group_id_list'), ',');
	for(i=1;i LTE arraylen(arrGroup);i++){
		arrGroup[i]=application.zcore.functions.zescape(arrGroup[i]);
	}
	userGroupIdSQL="'"&arrayToList(arrGroup, "','")&"'";
	db=request.zos.queryObject;
	db.sql="SELECT *, #db.trustedSQL(application.zcore.functions.zGetSiteIdSQL("user.user_id"))# as siteIDType
	FROM #db.table("user", request.zos.zcoreDatasource)# user 
	WHERE site_id = #db.param(request.zos.globals.id)#  ";
	if(arrayLen(arrGroup)){
		db.sql&=" and user_group_id in ("&db.trustedSQL(userGroupIdSQL)&")";
	}
	db.sql&=" ORDER BY user_first_name, user_last_name, user_username";
	qUser=db.execute("qUser");
	selectStruct = StructNew();
	if(application.zcore.functions.zso(arguments.optionStruct, 'user_multipleselection') EQ 'Yes'){
		selectStruct.multiple=true;
		selectStruct.size=5;
	}
	selectStruct.name = arguments.prefixString&arguments.row.site_option_id;
	selectStruct.query = qUser;
	selectStruct.selectedValues=application.zcore.functions.zso(arguments.dataStruct, '#arguments.prefixString##arguments.row.site_option_id#');
	selectStruct.queryParseLabelVars=true;
	selectStruct.queryParseValueVars=true;
	if(arguments.optionStruct.user_displaytype EQ 0){
		selectStruct.queryLabelField = "##user_first_name## ##user_last_name## (##user_username##)";
	}else if(arguments.optionStruct.user_displaytype EQ 1){
		selectStruct.queryLabelField = "##member_company## (##user_username##)";
	}else if(arguments.optionStruct.user_displaytype EQ 2){
		selectStruct.queryLabelField = "##user_username##";
	}
	selectStruct.queryValueField = "##user_id##|##siteIdType##";
	selectStruct.output=false;
	value=application.zcore.functions.zInputSelectBox(selectStruct);
	application.zcore.functions.zSetupMultipleSelect(selectStruct.name, selectStruct.selectedValues);
	
	
	return { label: true, hidden: false, value:value};  
	</cfscript>
</cffunction>

<cffunction name="getListValue" localmode="modern" access="public">
	<cfargument name="dataStruct" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfargument name="value" type="string" required="yes">
	<cfscript>
	db=request.zos.queryObject;
	returnValue="";
	arrUser=listToArray(arguments.value, "|");
	if(arraylen(arrUser) EQ 2){
		db.sql="select * from #db.table("user", request.zos.zcoreDatasource)# user 
		where site_id = #db.param(application.zcore.functions.zGetSiteIdFromSiteIdType(arrUser[2]))# and 
		user_id = #db.param(arrUser[1])# ";
		qUser=db.execute("qUser");
		if(qUser.recordcount NEQ 0){
			if(arguments.optionStruct.user_displaytype EQ 0){
				returnValue=qUser.user_first_name&" "&qUser.user_last_name&" ("&qUser.user_username&")";
			}else if(arguments.optionStruct.user_displaytype EQ 1){
				returnValue= qUser.member_company&" ("&qUser.user_username&")";
			}else if(arguments.optionStruct.user_displaytype EQ 2){
				returnValue=qUser.user_username;
			}
		}
	}
	return returnValue; 
	</cfscript>
</cffunction>

<cffunction name="onBeforeListView" localmode="modern" access="public" returntype="struct">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfargument name="dataStruct" type="struct" required="yes">
	<cfscript>
	return {};
	</cfscript>
</cffunction>

<cffunction name="onBeforeUpdate" localmode="modern" access="public">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes"> 
	<cfargument name="prefixString" type="string" required="yes">
	<cfargument name="dataStruct" type="struct" required="yes"> 
	<cfscript>	
	var nv=application.zcore.functions.zso(arguments.dataStruct, arguments.prefixString&arguments.row.site_option_id);
	return { success: true, value: nv, dateValue: "" };
	</cfscript>
</cffunction>

<cffunction name="getFormValue" localmode="modern" access="public">
	<cfargument name="row" type="struct" required="yes">
	<cfargument name="prefixString" type="string" required="yes">
	<cfargument name="dataStruct" type="struct" required="yes">
	<cfscript>
	return application.zcore.functions.zso(arguments.dataStruct, arguments.prefixString&arguments.row.site_option_id);
	</cfscript>
</cffunction>

<cffunction name="getTypeName" localmode="modern" access="public">
	<cfscript>
	return 'User Picker';
	</cfscript>
</cffunction>

<cffunction name="onUpdate" localmode="modern" access="public">
	<cfargument name="dataStruct" type="struct" required="yes">
	<cfscript>
	var error=false;
	if(false){
		application.zcore.status.setStatus(request.zsid, "Message");
		error=true;
	}
	if(error){
		application.zcore.status.setStatus(Request.zsid, false,arguments.dataStruct,true);
		return { success:false};
	}
	ts={
		user_group_id_list:application.zcore.functions.zso(arguments.dataStruct, 'user_group_id_list'),
		user_displaytype:application.zcore.functions.zso(form, 'user_displaytype'),
		user_multipleselection:application.zcore.functions.zso(form, 'user_multipleselection')
	};
	arguments.dataStruct.site_option_type_json=serializeJson(ts);
	return { success:true};
	</cfscript>
</cffunction>
		

<cffunction name="getTypeForm" localmode="modern" access="public">
	<cfargument name="dataStruct" type="struct" required="yes">
	<cfargument name="optionStruct" type="struct" required="yes">
	<cfargument name="fieldName" type="string" required="yes">
	<cfscript>
	var db=request.zos.queryObject;
	var output="";
	var value=application.zcore.functions.zso(arguments.dataStruct, arguments.fieldName);
	
	</cfscript>
	<cfsavecontent variable="output">
	<input type="radio" name="site_option_type_id" value="16" onClick="setType(16);" <cfif value EQ "16">checked="checked"</cfif>/>
	User Picker<br />
		<div id="typeOptions16" style="display:none;padding-left:30px;"> 
			<table style="border-spacing:0px;">
			<tr><td>Display Type: </td><td>
			<cfscript>
			arguments.optionStruct.user_displaytype=application.zcore.functions.zso(arguments.optionStruct, 'user_displaytype', true, 0);
			var ts = StructNew();
			ts.name = "user_displaytype";
			ts.style="border:none;background:none;";
			ts.labelList = "First/Last Name/Email,Company/Email,Email";
			ts.valueList = "0,1,2";
			ts.hideSelect=true;
			ts.struct=arguments.optionStruct;
			writeoutput(application.zcore.functions.zInput_RadioGroup(ts));
			</cfscript>
			</td></tr>
			<tr><td style="vertical-align:top;">Limit User Groups: </td>
			<td>
			<cfscript>
			form.user_group_id_list=application.zcore.functions.zso(arguments.optionStruct, 'user_group_id_list');
			db.sql="SELECT *FROM #db.table("user_group", request.zos.zcoreDatasource)# user_group 
			WHERE site_id = #db.param(request.zos.globals.id)#  
			ORDER BY user_group_name asc"; 
			var qGroup2=db.execute("qGroup2"); 
			ts = StructNew();
			ts.name = "user_group_id_list";
			ts.friendlyName="";
			// options for query data
			ts.query = qGroup2;
			ts.queryLabelField = "user_group_name";
			ts.queryValueField = "user_group_id";
			writeoutput(application.zcore.functions.zInput_Checkbox(ts));
			</cfscript></td></tr>
			<tr><td>Multiple Selections: </td><td>
			<cfscript>
			arguments.optionStruct.user_multipleselection=application.zcore.functions.zso(arguments.optionStruct, 'user_multipleselection', false, "No");
			if(arguments.optionStruct.user_multipleselection EQ ""){
				arguments.optionStruct.user_multipleselection="No";
			}
			var ts = StructNew();
			ts.name = "user_multipleselection";
			ts.style="border:none;background:none;";
			ts.labelList = "Yes,No";
			ts.valueList = "Yes,No";
			ts.hideSelect=true;
			ts.struct=arguments.optionStruct;
			writeoutput(application.zcore.functions.zInput_RadioGroup(ts));
			</cfscript>
			</td></tr>
			</table>
		</div>
	</cfsavecontent>
	<cfreturn output>
</cffunction> 
</cfoutput>
</cfcomponent>