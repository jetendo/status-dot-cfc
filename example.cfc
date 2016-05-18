<cfcomponent>
	<cfoutput>
	<cffunction name="index" access="remote">
    	<cfscript>
		var status=createobject("component", "status");
		var zsid=0;
		var zsid2=0;
		var struct1={};
		var struct2={};
		var temp=0;
		var temp2=0;
		writeoutput('<h1>status-dot-cfc examples</h1>');
		writeoutput('<p>Note: To reduce memory usage, status.cfc doesn''t store data in request.zsession memory until it needs to.</p>');
		
		writeoutput('<h2>init status with a different key to storage the request.zsession data in.</h2>');
		writeoutput('<pre>status.init({ request.zsessionKey: "statusKey"});</pre>');
		status.init({ request.zsessionKey: "statusKey"});
		
		writeoutput('<style type="text/css">pre{ background-color:##F9F9F9; padding:5px; border:1px solid ##CCC;} </style>');
		
		writeoutput('<h2>Create 2 unique status ids</h2>');
		writeoutput('<pre>zsid=status.getNewId();
zsid2=status.getNewId();</pre>');
		zsid=status.getNewId();
		zsid2=status.getNewId();
		writeoutput('<p>zsid: '&zsid&'<br />zsid2: '&zsid2&'</p><hr />');
		
		writeoutput('<h2>Set status message for 2 unique status ids</h2>');
		writeoutput('<pre>status.setStatus(zsid, "Status Message");
status.setStatus(zsid2, "Status Message 2");</pre>');
		status.setStatus(zsid, "Status Message");
		status.setStatus(zsid2, "Status Message 2");
		writeoutput('<hr />');
		
		writeoutput('<h2>Display status messages for both status ids</h2>');
		writeoutput('<pre>status.display(zsid);
status.display(zsid2);</pre>');
		status.display(zsid);
		status.display(zsid2);
		writeoutput('<hr />');
		
		writeoutput('<h2>Delete all stored data for both status ids</h2>');
		writeoutput('<pre>status.deleteId(zsid);
status.deleteId(zsid2);</pre>');
		status.deleteId(zsid);
		status.deleteId(zsid2);
		writeoutput('<hr />');
		
		writeoutput('<h2>Display deleted status id to show the informational was deleted. Nothing is output when the id doesn''t exist.</h2>');
		writeoutput('<pre>status.display(zsid);</pre>');
		status.display(zsid);
		writeoutput('<hr />');
		
		writeoutput('<h2>Set multiple status error messages</h2>');
		writeoutput('<pre>zsid=status.getNewId();
status.setStatus(zsid, "Error Message", false, true);
status.setStatus(zsid, "Error Message 2", false, true);</pre>');
		zsid=status.getNewId();
		status.setStatus(zsid, "Error Message", false, true);
		status.setStatus(zsid, "Error Message 2", false, true);
		writeoutput('<hr />');
		
		writeoutput('<h2>Set a status error message and store a structure in request.zsession memory.</h2>');
		writeoutput('<pre>struct1.name="John";
struct1.phone="123-555-1234";
status.setStatus(zsid, "Error Message", struct1, true);</pre>');
		struct1.name="John";
		struct1.phone="123-555-1234";
		status.setStatus(zsid, "Error Message", struct1, true);
		writeoutput('<hr />');
		
		
		writeoutput('<h2>Copy stored status struct into form scope, silence status message output and dump the form scope.</h2>');
		writeoutput('<pre>status.display(zsid, true, true);
writedump(form);</pre>');
		status.display(zsid, true, true);
		writedump(form);
		writeoutput('<hr />');
		
		writeoutput('<h2>Copy stored status struct into "struct2" struct, output status message output and dump "struct2".</h2>');
		writeoutput('<pre>status.display(zsid, true, false, struct2);
writedump(struct2);</pre>');
		status.display(zsid, true, false, struct2);
		writedump(struct2);
		writeoutput('<hr />');
		
		writeoutput('<h2>Retrieve all stored data for the specified status id from memory</h2>');
		writeoutput('<pre>struct2=status.getStruct(zsid);
writedump(struct2);</pre>');
		struct2=status.getStruct(zsid);
		writedump(struct2);
		writeoutput('<hr />');
		
		writeoutput('<h2>Retrieve the "Name" field from the stored struct for the specified status id.</h2>');
		writeoutput('<pre>temp=status.getField(zsid, ''Name'');</pre>');
		temp=status.getField(zsid, 'Name');
		writeoutput('<p>Name:'&temp&'</p>');
		writeoutput('<hr />');
		
		writeoutput('<h2>Set and retrieve the "Name" field from the stored struct for the specified status id.</h2>');
		writeoutput('<pre>temp=status.setField(zsid, ''Name'', ''Joe'');
temp=status.getField(zsid, ''Name'');</pre>');
		temp=status.setField(zsid, 'Name', 'Joe');
		temp=status.getField(zsid, 'Name');
		writeoutput('<p>Name:'&temp&'</p>');
		writeoutput('<hr />');
		
		
		writeoutput('<h2>Set and retrieve the "Name" field from the stored struct for the specified status id.</h2>');
		writeoutput('<pre>status.setFieldError(zsid, ''Name'', true);
temp=status.checkFieldError(zsid, ''Name'');</pre>');
		status.setFieldError(zsid, 'Name', true);
		temp=status.checkFieldError(zsid, 'Name');
		writeoutput('<p>Name has field error:'&temp&'</p>');
		writeoutput('<hr />');
		
		
		writeoutput('<h2>Remove "Name" field error for the specified status id.</h2>');
		writeoutput('<pre>status.setFieldError(zsid, ''Name'', false);
temp=status.checkFieldError(zsid, ''Name'');</pre>');
		status.setFieldError(zsid, 'Name', false);
		temp=status.checkFieldError(zsid, 'Name');
		writeoutput('<p>Name has field error:'&temp&'</p>');
		writeoutput('<hr />');
		
		
		writeoutput('<h2>Retrieve and dump error message array for the specified status id.</h2>');
		writeoutput('<pre>status.getErrors(zsid);
writedump(temp);</pre>');
		temp=status.getErrors(zsid);
		writedump(temp);
		writeoutput('<hr />');
		
		
		writeoutput('<h2>Return the errorClass when a field has an error otherwise the regularClass for the specified status id.</h2>');
		writeoutput("<pre>temp=status.getErrorStyle(zsid, 'Name', 'fieldErrorClass', 'fieldClass');
status.setFieldError(zsid, 'Name', true);
temp2=getErrorStyle(zsid, 'Name', 'fieldErrorClass', 'fieldClass');</pre>");
		temp=status.getErrorStyle(zsid, 'Name', 'fieldErrorClass', 'fieldClass');
		status.setFieldError(zsid, 'Name', true);
		temp2=status.getErrorStyle(zsid, 'Name', 'fieldErrorClass', 'fieldClass');
		writeoutput("<p>CSS Class Name:"&temp&'</p>');
		writeoutput("<p>CSS Class Name:"&temp2&'</p>');
		writeoutput('<hr />');
		
		
		writeoutput('<h2>Set the error field struct for the specified status id.</h2>');
		writeoutput("<pre>struct1={'Name':true,'Phone':false};
status.setErrorFieldStruct(zsid, struct1);
temp=status.checkFieldError(zsid, 'Name');
temp2=status.checkFieldError(zsid, 'Phone');</pre>");
		struct1={"Name":true,"Phone":false};
		status.setErrorFieldStruct(zsid, struct1);
		temp=status.checkFieldError(zsid, 'Name');
		temp2=status.checkFieldError(zsid, 'Phone');
		writeoutput("<p>'Name' has field error:"&temp&'</p>');
		writeoutput("<p>'Phone' has field error:"&temp2&'</p>');
		writeoutput('<hr />');
		
		
		writeoutput('<h2>Set the error struct for the specified status id and display all status messages.</h2>');
		writeoutput("<pre>status.deleteId(zsid);
struct1={'Name':'The ""Name"" field is required.'};
status.setErrorStruct(zsid, struct1);
status.display(zsid);</pre>");
		status.deleteId(zsid);
		struct1={'Name':'The "Name" field is required.'};
		status.setErrorStruct(zsid, struct1);
		status.display(zsid);
		writeoutput('<hr />');
		
		
		writeoutput('<h2>Delete all status request.zsession data for the current user.</h2>');
		writeoutput("<pre>status.deleteSessionData();</pre>");
		status.deleteSessionData();
		writeoutput('<hr />');
		
		</cfscript>
    </cffunction>
    </cfoutput>
</cfcomponent>