<cfoutput>
<h1>New List</h1>
<form action="#buildUrl('.create')#" method="POST">
	<label for="name">List name: </label>
	<input id="name" type="text" name="name" />
	<button type="submit" class="btn btn-default">Save</button>
</form>
</cfoutput>