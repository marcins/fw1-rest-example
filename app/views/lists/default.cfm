<cfoutput>
<h1>Lists</h1>
<ul>
<cfloop array="#rc.lists#" index="list">
	<li><a href="#getBaseUrl()#/index.cfm/lists/#list.id#">#list.name#</a></li>
</cfloop>
</ul>

<a href="#buildUrl(action='.new')#">New list</a>
</cfoutput>