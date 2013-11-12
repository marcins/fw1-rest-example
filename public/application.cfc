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

	public void function before (required any rc) {
		rc.baseUrl = resolveBaseUrl();
	}

	private string function resolveBaseUrl () {
		var path = getBaseUrl();
		if ( path == 'useSubsystemConfig' ) {
			var subsystemConfig = getSubsystemConfig( getSubsystem( action ) );
			if ( structKeyExists( subsystemConfig, 'baseURL' ) ) {
				path = subsystemConfig.baseURL;
			} else {
				path = getBaseURL();
			}
		}
		if ( path == 'useCgiScriptName' ) {
			path = request._fw1.cgiScriptName;
			if ( variables.framework.SESOmitIndex ) {
				path = getDirectoryFromPath( path );
			}
		} else if ( path == 'useRequestURI' ) {
			path = getPageContext().getRequest().getRequestURI();
			if ( variables.framework.SESOmitIndex ) {
				path = getDirectoryFromPath( path );
			}
		}
		return path;
	}

}