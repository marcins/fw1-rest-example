<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>FW/1 REST Example</title>
	<link rel="stylesheet" href="/rest-example/stylesheets/bootstrap.min.css" />
	<link rel="stylesheet" href="/rest-example/stylesheets/bootstrap-theme.min.css" />
	<link rel="stylesheet" href="/rest-example/stylesheets/example.css" />
</head>
<body>
<cfoutput><div class="container">#body#

<footer class="row">
	<div class="col-md-12">
		<p>Icons courtesy of <a href="http://glyphicons.com/">glyphicons</a></p>
	</div>
</footer></cfoutput>
<cfoutput><script>window.Example = { baseUrl: "#rc.baseUrl#" };</script></cfoutput>
<script src="/rest-example/javascripts/jquery-2.0.3.min.js" type="text/javascript"></script>
<script src="/rest-example/javascripts/example.js" type="text/javascript"></script>
</body>
</html>