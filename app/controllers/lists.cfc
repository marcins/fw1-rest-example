component output="false" displayname="" accessors="true"  {

	property objectStore;

	public function init(required any fw){
		variables.fw = arguments.fw;
		return this;
	}

	public void function default (required any rc)
	{
		param name="rc.type" default="";
		rc.lists = getObjectStore().getObjectsByProperty("type", "list");
		switch (rc.contentType) {
			case "json":
			fw.renderData("json", rc.lists);
			break;
			case "html":
			break;
		}
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

	public void function show (required any rc)
	{
		rc.list = getObjectStore().getObjectById(rc.id);
		if (isNull(rc.list)) {
			if (rc.contentType == "json") {
				return fw.renderData("json", {error = "List not found"}, 404);
			} else {
				throw(message="List not found");
			}
		} else {
			rc.listItems = getObjectStore().getObjectsByProperty("listId", rc.list.id);
		}
	}

}