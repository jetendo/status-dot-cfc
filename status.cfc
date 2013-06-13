<!--- 
status.cfc
Version: 0.1.002

Project Home Page: Coming soon
Github Home Page: https://github.com/jetendo/status-dot-cfc

Licensed under the MIT license
http://www.opensource.org/licenses/mit-license.php
Copyright (c) 2013 Far Beyond Code LLC.
 --->
<cfcomponent displayname="Status Message System" hint="" output="no">
	<cfoutput>   
	<cffunction name="init" access="public" output="no">
    	<cfargument name="config" type="struct" required="no" default="#{}#">
        <cfscript>
		var root=expandPath("/");
		var configDefault={
			sessionKey:"zStatusStruct"
		};
		structappend(variables, configDefault, true);
		structappend(variables, arguments.config, true);
		variables.initRun=true;
        </cfscript>
    </cffunction>
    
	<cffunction name="initSession" access="private" returntype="any" output="no">
    	<cfscript>
		if(not structkeyexists(variables,'initRun')){
			this.init();
		}
		if(not structkeyexists(session, variables.sessionKey)){
			session[variables.sessionKey] = {
				count = 0,
				id = 0,
				dataCount = 0
			};
		}
		</cfscript>
    </cffunction>
	
	<!--- statusCom.getStruct(id); --->
	<cffunction name="getStruct" access="public" returntype="any" output="false">
		<cfargument name="id" type="string" required="yes">
        <cfscript>
		var local={};
		if(not structkeyexists(variables, 'initRun') or not structkeyexists(session, variables.sessionKey)) variables.initSession();
		</cfscript>
		<cfif isNumeric(arguments.id) EQ false>
			<cfif find("@",arguments.id) NEQ 0>
				Invalid Request
				<cfscript>
				request.zos.functions.zabort();
				</cfscript>
			</cfif>
		</cfif>
		<cfscript>
		if(structkeyexists(session[variables.sessionKey], arguments.id)){// and structkeyexists(session[variables.sessionKey][arguments.id], 'varStruct')){
			return session[variables.sessionKey][arguments.id];
		
		}else{
			// force it to exist and then return it
			session[variables.sessionKey][arguments.id]={
				arrMessages = ArrayNew(1),
				arrErrors = ArrayNew(1),
				errorStruct = StructNew(),
				varStruct = StructNew(),
				errorFieldStruct = StructNew()
			};
			if(structkeyexists(session[variables.sessionKey],'count') EQ false or arguments.id GT session[variables.sessionKey].count){
				session[variables.sessionKey].count = arguments.id;
			}
			return session[variables.sessionKey][arguments.id];
		}
		</cfscript>
	</cffunction>
	
	<!--- statusCom.getNewId(); --->
	<cffunction name="getNewId" access="public" returntype="any" output="false" hint="Create new id">
		<cfscript>
		if(not structkeyexists(variables, 'initRun') or not structkeyexists(session, variables.sessionKey)) variables.initSession();
		if(isnumeric(session[variables.sessionKey].count) EQ false){
			session[variables.sessionKey].count=0;
		}
		session[variables.sessionKey].id = session[variables.sessionKey].count+1;
		session[variables.sessionKey].count = session[variables.sessionKey].id;
		return session[variables.sessionKey].id;
		</cfscript>
	</cffunction>
    
    
	<!--- statusCom.deleteId(id); --->
	<cffunction name="deleteId" access="public" returntype="any" output="false" hint="Delete status id">
		<cfargument name="id" type="numeric" required="yes">
		<cfscript>
		if(structkeyexists(session, variables.sessionKey) and structkeyexists(session[variables.sessionKey], arguments.id)){
			structdelete(session[variables.sessionKey], arguments.id);
		}
		</cfscript>
	</cffunction>
    
	<!--- statusCom.deleteSessionData(); --->
	<cffunction name="deleteSessionData" access="public" returntype="any" output="false" hint="Delete status id">
		<cfscript>
		structdelete(session, variables.sessionKey);
		structdelete(variables, 'statusStruct');
		</cfscript>
	</cffunction>
	
	<!--- statusCom.setFieldError(id, fieldName, isError); --->
	<cffunction name="setFieldError" access="public" output="false" hint="Mark a field as having an generated an error." returntype="any">
		<cfargument name="id" type="numeric" required="yes">
		<cfargument name="fieldName" required="yes" type="string">
		<cfargument name="isError" required="no" type="boolean" default="#true#">
		<cfscript>
		var statusStruct = this.getStruct(arguments.id);
		if(arguments.isError){
			statusStruct.errorFieldStruct[arguments.fieldName]=true;
		}else{
			structdelete(statusStruct.errorFieldStruct, arguments.fieldName);
		}
		</cfscript>
	</cffunction>
    
	
	<!--- statusCom.setStatus(id, status, varStruct, error); --->
	<cffunction name="setStatus" access="public" returntype="any" output="false">
		<cfargument name="id" type="string" required="yes">
		<cfargument name="status" type="any" required="no" default="#false#">
		<cfargument name="varStruct" type="any" required="no" default="#StructNew()#">
		<cfargument name="error" type="boolean" required="no" default="#false#">
        <cfscript>
		var local=structnew();
		var statusStruct=0;
		if(not structkeyexists(variables, 'initRun') or not structkeyexists(session, variables.sessionKey)) variables.initSession();
		</cfscript>
		<cfif isNumeric(arguments.id) EQ false>
			<cfif find("@",arguments.id) NEQ 0>
				Invalid Request
				<cfscript>
				request.zos.functions.zabort();
				</cfscript>
			<cfelse>
				<cfscript>
				request.zos.template.fail("zcorerootmapping.com.zos.status.cfc: setStatus: id must be numeric");
				</cfscript>
			</cfif>
		</cfif>
		<cfscript>
		statusStruct = this.getStruct(arguments.id);
		if(arguments.status NEQ false){
			session[variables.sessionKey].dataCount++;
			if(arguments.error){
				local.exists=false;
				for(local.i=1;local.i LTE arraylen(statusStruct.arrErrors);local.i++){
					if(statusStruct.arrErrors[local.i] EQ arguments.status){
						local.exists=true;	
						break;
					}
				}
				if(local.exists EQ false){
					ArrayAppend(statusStruct.arrErrors, arguments.status);	
				}
			}else{
				local.exists=false;
				for(local.i=1;local.i LTE arraylen(statusStruct.arrMessages);local.i++){
					if(statusStruct.arrMessages[local.i] EQ arguments.status){
						local.exists=true;	
						break;
					}
				}
				if(local.exists EQ false){
					ArrayAppend(statusStruct.arrMessages, arguments.status);
				}
			}
		}
		/*
		if(structkeyexists(statusStruct,'varStruct') EQ false){
			session[variables.sessionKey][arguments.id]={
				arrMessages = ArrayNew(1),
				arrErrors = ArrayNew(1),
				errorStruct = StructNew(),
				varStruct = StructNew(),
				errorFieldStruct = StructNew()
			};
		}
		*/
		if(structkeyexists(session[variables.sessionKey],'dataStruct') EQ false){
			session[variables.sessionKey].dataStruct=0;
		}
		if(isStruct(arguments.varStruct)){
			session[variables.sessionKey].dataCount++;
			StructAppend(statusStruct.varStruct, arguments.varStruct, true);
		}
		return arguments.id;
		</cfscript>
	</cffunction>
	
	<!--- statusCom.getField(id, fieldName, defaultValue); --->
	<cffunction name="getField" access="public" returntype="any" output="false">
		<cfargument name="id" type="string" required="yes">
		<cfargument name="fieldName" type="string" required="yes">
		<cfargument name="defaultValue" type="any" required="no" default="">
		<cfscript>
		if(not structkeyexists(variables, 'initRun') or not structkeyexists(session, variables.sessionKey)) variables.initSession();
		if(structkeyexists(session,'zos') and structkeyexists(session[variables.sessionKey],arguments.id) and structkeyexists(session[variables.sessionKey][arguments.id].varStruct, arguments.fieldName)){
			return session[variables.sessionKey][arguments.id].varStruct[arguments.fieldName];
		}else{
			return arguments.defaultValue;
		}
		</cfscript>
	</cffunction>
	
	
	
	<!--- statusCom.setField(id, fieldName, value); --->
	<cffunction name="setField" access="public" returntype="any" output="false">
		<cfargument name="id" type="string" required="yes">
		<cfargument name="fieldName" type="string" required="yes">
		<cfargument name="value" type="any" required="yes">
		
		<cfscript>
		var statusStruct=0;
		if(not structkeyexists(variables, 'initRun') or not structkeyexists(session, variables.sessionKey)) variables.initSession();
		statusStruct = this.getStruct(arguments.id);
		StructInsert(statusStruct.varStruct, arguments.fieldName, arguments.value, true);
		</cfscript>
	</cffunction>
	
	
	<!--- getErrorCount(id); --->
	<cffunction name="getErrorCount" access="public" returntype="any" output="true">
		<cfargument name="id" type="string" required="yes">
		<cfscript>
		var statusStruct = this.getStruct(arguments.id);
		return ArrayLen(statusStruct.arrErrors)+StructCount(statusStruct.errorStruct);
		</cfscript> 
	</cffunction>
	
	<!--- getErrors(id); --->
	<cffunction name="getErrors" access="public" returntype="any" output="true">
		<cfargument name="id" type="string" required="yes">
		<cfscript>
		var i = "";
		var arrTemp = ArrayNew(1); 
		if(not structkeyexists(variables, 'initRun') or not structkeyexists(session, variables.sessionKey)) variables.initSession();
		if(structkeyexists(session[variables.sessionKey],arguments.id)){
			arrTemp = duplicate(session[variables.sessionKey][arguments.id].arrErrors);
			
			for(i in session[variables.sessionKey][arguments.id].errorStruct){
				ArrayAppend(arrTemp, session[variables.sessionKey][arguments.id].errorStruct[i]);
			}		
		}
		return arrTemp;
		</cfscript> 
	</cffunction>
	
	<!--- getErrorStyle(id, fieldName, errorClass, regularClass); --->
	<cffunction name="getErrorStyle" access="public" returntype="any" output="false">
		<cfargument name="id" type="numeric" required="yes">
		<cfargument name="fieldName" type="string" required="yes">
		<cfargument name="errorClass" type="string" required="yes">
		<cfargument name="regularClass" type="string" required="no" default="">
		<cfscript>
		if(this.checkFieldError(arguments.id, arguments.fieldName)){
			return ' class="'&arguments.errorClass&'" ';
		}else{
			if(len(arguments.regularClass)){
				return ' class="'&arguments.regularClass&'" ';
			}else{
				return "";
			}
		}
		</cfscript>
	</cffunction>
	
	<!--- checkFieldError(id, fieldName); --->
	<cffunction name="checkFieldError" access="public" returntype="any" output="false">
		<cfargument name="id" type="numeric" required="yes">
		<cfargument name="fieldName" type="string" required="yes">
		<cfscript>
		if(structkeyexists(session[variables.sessionKey],arguments.id) and structkeyexists(session[variables.sessionKey][arguments.id].errorFieldStruct, arguments.fieldName)){
			return true;
		}else{
			return false;
		}
		</cfscript>
	</cffunction>
	
	<!--- statusCom.setErrorFieldStruct(id, struct); --->
	<cffunction name="setErrorFieldStruct" access="public" returntype="any" output="false">
		<cfargument name="id" type="numeric" required="yes">
		<cfargument name="struct" type="struct" required="yes">
		<cfscript>
		var statusStruct = this.getStruct(arguments.id);
		var i=0;
		for(i in struct){
			if(not struct[i]){
				structdelete(struct, i);
			}
		}
		StructAppend(statusStruct.errorFieldStruct, arguments.struct);
		</cfscript>
	</cffunction>
	
	<!--- statusCom.setErrorStruct(id, struct); --->
	<cffunction name="setErrorStruct" access="public" returntype="any" output="false">
		<cfargument name="id" type="numeric" required="yes">
		<cfargument name="struct" type="struct" required="yes">
		<cfscript>
		var statusStruct = this.getStruct(arguments.id);
		var i=0;
		var struct2={};
		for(i IN arguments.struct){
			struct2[i]=true;
		}
		this.setErrorFieldStruct(arguments.id, struct2);
		StructAppend(statusStruct.errorStruct, arguments.struct);
		</cfscript>
	</cffunction>
    
    
    <cffunction name="display" access="public" returntype="any" output="true">
        <cfargument name="id" type="string" required="yes">
        <cfargument name="getVars" type="boolean" required="no" default="#false#">
        <cfargument name="silent" type="boolean" required="no" default="#false#">
        <cfargument name="targetStruct" type="struct" required="no" default="#form#">
        <cfscript>
        var statusStruct = StructNew();
        var arrErrors = ArrayNew(1);
        statusStruct = this.getStruct(arguments.id);
        arrErrors = this.getErrors(arguments.id);
        if(structkeyexists(statusStruct, 'arrMessages')){
            if(arguments.getVars){
                StructAppend(arguments.targetStruct, statusStruct.varStruct, true);
            }
            if(arguments.silent EQ false){
                if(ArrayLen(statusStruct.arrMessages) GT 0 or ArrayLen(arrErrors) GT 0){
                    writeoutput('<div style="float:left;width:100%;"><div style=" width:100%; overflow:hidden; display:block; clear:both; border-bottom:1px solid ##660000; margin-bottom:10px;">');
                }
                if(ArrayLen(statusStruct.arrMessages) GT 0){
                    writeoutput('<div style="display:block; clear:both;float:left; color:##FFFFFF; width:98%; padding:1%; background-color:##990000; font-weight:bold;">Status:</div>');
                    writeoutput('<div style="display:block; clear:both;float:left; color:##000000;width:98%; padding:1%; background-color:##FFFFFF;">'&ArrayToList(statusStruct.arrMessages, '<hr />')&'</div>');
                    if(ArrayLen(arrErrors) GT 0){
                        writeoutput('');
                    }
                }
                if(ArrayLen(arrErrors) GT 0){
                    writeoutput('<div style="display:block; clear:both;float:left; color:##FFFFFF; width:98%; padding:1%; font-weight:bold; background-color:##993333;">The following errors occurred:</div>');
                    writeoutput('<div style="display:block; clear:both;float:left; color:##000000; width:98%; padding:1%; background-color:##FFFFFF;">'&ArrayToList(arrErrors, '<hr />')&'</div>');
                }
                if(ArrayLen(statusStruct.arrMessages) GT 0 or ArrayLen(arrErrors) GT 0){
                    writeoutput('</div></div><br style="clear:both;" />');
                }
            }
        }
        </cfscript>
    </cffunction>
    
</cfoutput>
</cfcomponent>