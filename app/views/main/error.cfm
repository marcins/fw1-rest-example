<cfheader statuscode="500" statustext="An error has occured" />
<h1>An error occured</h1>
<cfoutput>
<cfif structKeyExists(request, "exception")>
	<h2>#request.exception.message#</h2>
	<section class="error">
	<p><strong>Message:</strong> #request.exception.message#</p>
	<p><strong>Root Cause Message:</strong> #request.exception.rootCause.message#</p>
	<cfif isDefined("request.exception.rootCause.detail") AND request.exception.rootCause.detail NEQ "">
	<p><strong>Root Cause Detail:</strong>>#request.exception.rootCause.detail#</p>
	</cfif>
	</section>
	<cftry>
	<h2>RC</h2>
	<cfdump var="#rc#" />
	<cfcatch type="any">
	<em>RC is not available.</em>
	</cfcatch>
	</cftry>
	<h2>Exception Detail</h2>
	<cfdump var="#request.exception#" />
	<h2>CGI</h2>
	<cfdump var="#cgi#" />
	<h2>Server</h2>
	<cfdump var="#server#" />
</cfif>
</cfoutput>