component extends="org.corfield.framework" {
	this.name = "FW/1 REST Example";

	this.mappings["/app"] = expandPath("../app");

	variables.framework = {
		base = "/app/",
		reloadApplicationOnEveryRequest = true,
		trace = false,
		routes = [{
			"$RESOURCES" = { resources = "lists", nested = "items" }
		}]
	};

	if (structKeyExists(url, "_method") && cgi.request_method == 'POST' && listFindNoCase('put,patch,delete', url._method)) {
		request._fw1.cgiRequestMethod = url._method;
	}

	public void function setupApplication () {
		var beanProperties = {
			databasePath = expandPath("../db/database.json"),
			seedPath = expandPath("/app/seed.json")
		};

		var beanFactory = new org.corfield.ioc("/app/model", { constants = beanProperties });
		setBeanFactory(beanFactory);
	}

	public void function setupRequest () {
		if (structKeyExists(url, "reload")) {
			setupApplication();
		}
	}

}