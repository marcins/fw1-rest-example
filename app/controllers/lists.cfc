component output="false" displayname="" accessors="true"  {

	property objectStore;

	public function init(required any fw){
		variables.fw = arguments.fw;
		return this;
	}

	public void function default (required any rc)
	{
		rc.lists = getObjectStore().getObjectsByProperty("type", "list");
	}

	public void function create (required any rc)
	{
		param name="rc.name" default="";

		if (rc.name == "") throw(message="Name required");
		var existingList = getObjectStore().getObjectByFilterFunction(function (object) {
			return object.type == "list" && object.name == rc.name;
		});

		if (isNull(existingList)) {
			var list = {};
			list["name"] = rc.name;
			list["type"] = "list";
			getObjectStore().setObject(list);
			fw.redirect(".default");
		} else {
			throw(message="Exsiting!");
		}

	}

}