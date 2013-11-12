component output="false" displayname="" accessors="true"  {

	property objectStore;

	public function init(required any fw){
		variables.fw = arguments.fw;
		return this;
	}

	public void function default (required any rc)
	{
		var list = getObjectStore().getObjectById(rc.lists_id);
		if (isNull(list)) {
			return fw.renderData("json", {error = "List not found"}, 404);
		} else {
			var listItems = getObjectStore().getObjectsByProperty("listId", list.id);
			return fw.renderData("json", listItems);
		}
	}

	public void function create (required any rc)
	{
		var list = getObjectStore().getObjectById(rc.lists_id);
		if (isNull(list)) {
			return fw.renderData("json", {error = "List not found"}, 404);
		} else {
			var item = {};
			item["label"] = rc.label;
			item["complete"] = false;
			item["type"] = "listItem";
			item["listId"] = rc.lists_id;
			getObjectStore().setObject(item);
			list.itemCount++;
			getObjectStore().setObject(list);
			fw.renderData("json", item);
		}
	}

	public void function update (required any rc)
	{
		var item = getObjectStore().getObjectByProperties(listId = rc.lists_id, id = rc.id, type = "listItem");
		if (isNull(item)) {
			return fw.renderData("json", {error = "Item not found"}, 404);
		} else {
			item['complete'] = javaCast("boolean", rc.complete);
			getObjectStore().setObject(item);
			fw.renderData("json", item);
		}
	}

	public void function show (required any rc)
	{
		var item = getObjectStore().getObjectByProperties(listId = rc.lists_id, id = rc.id, type = "listItem");
		if (isNull(item)) {
			return fw.renderData("json", {error = "Item not found"}, 404);
		} else {
			fw.renderData("json", item);
		}
	}

}