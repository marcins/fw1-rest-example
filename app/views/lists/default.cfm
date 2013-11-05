<cfoutput>
<h1>Lists</h1>
<ul>
<cfloop array="#rc.lists#" index="list">
	<li><a href="#getResolvedBaseUrl()#/lists/#list.id#">#list.name#</a></li>
</cfloop>
</ul>

<a href="#getResolvedBaseUrl()#/lists/new">New list</a>
</cfoutput>