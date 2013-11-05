<cfoutput>
<h1>List: #rc.list.name#</h1>

<ul>
<cfloop array="#rc.listItems#" index="item">
	<li>#item.label#</li>
</cfloop>
</ul>
</cfoutput>