component output="false" displayname="" accessors="true"  {

	property name="objectStore";

	public function init(required any fw){
		variables.fw = fw;
		return this;
	}

	public void function login (required any rc)
	{
		param name="rc.username" default="";
		param name="rc.password" default="";

		var user = getObjectStore().getObjectByFilterFunction(function (object) {
			return (structKeyExists(object, "type") && object.type == "user" &&
				object.username == rc.username && object.password == rc.password);
		});
		if (isNull(user)) {
			header statusCode="401" statusText="Unauthorized";
			fw.renderData("json", {error: "Unauthorized"});
		} else {
			user['token'] = createUUID();
			user['loginTime'] = now();
			getObjectStore().setObject(user);
			fw.renderData("json", user.token);
		}
	}
}