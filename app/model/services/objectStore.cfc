/**
* This is a simple persistent object store, do NOT use this production
*/
component output="false" displayname="" accessors="true"  {

	property databasePath;
	property seedPath;

	public function init(string databasePath = "", string seedPath = ""){
		setDatabasePath(databasePath);
		setSeedPath(seedPath);
		variables.objects = [];
		variables.objectsById = {};
		if (getDatabasePath() != "") {
			_loadDatabase();
		}
		return this;
	}

	public void function setObject(required struct data)
	{
		lock name="objectAccess" type="exclusive" timeout="30" {
			if (structKeyExists(data, "id") && structKeyExists(variables.objectsById, data.id)) {
				for (var i = 1; i <= ArrayLen(variables.objects); i++) {
					if (variables.objects[i].id == data.id) {
						arrayDeleteAt(variables.objects, i);
						break;
					}
				}
			} else if(!structKeyExists(data, "id")) {
				data['id'] = createUUID();
			}
			arrayAppend(variables.objects, data);
			variables.objectsById[data.id] = data;
			_saveDatabase();
		}
	}

	public any function getObjectById(required string id)
	{;
		lock name="objectAccess" type="exclusive" timeout="30" {
			if (structKeyExists(variables.objectsById, arguments.id)) {
				return variables.objectsById[arguments.id];
			}
		}
		return _null();
	}

	public array function getObjectsByFilterFunction(required function filter)
	{
		var objects = [];
		lock name="objectAccess" type="exclusive" timeout="30" {
			for (var object in variables.objects) {
				try {
					if(filter(object)) {
						arrayAppend(objects, object);
					}
				} catch(any e) {
					writeLog(text="Filter function failed: #e.message#", severity="error");
					// ignore objects we can't read right
				}
			}
		}
		return objects;
	}

	public any function getObjectByFilterFunction(required function filter)
	{
		var results = getObjectsByFilterFunction(filter);
		return _returnOne(results);
	}

	public array function getObjectsByProperties()
	{
		var keys = structKeyArray(arguments);
		var args = arguments;
		var objects = getObjectsByFilterFunction(function (object) {
			for (var property in keys) {
				if (not structKeyExists(object, property) || not object[property] == args[property]) {
					return false;
				}
			}
			return true;
		});
		return objects;
	}

	public any function getObjectByProperties()
	{
		var results = getObjectsByProperties(argumentCollection=arguments);
		return _returnOne(results);
	}

	public array function getObjectsByProperty(required string property, required any value)
	{
		var args = {};
		args[property] = value;
		return getObjectsByProperties(argumentCollection=args);
	}

	public struct function getObjectByProperty(required string property, required any value)
	{
		var results = getObjectsByProperty(argumentCollection=arguments);
		return _returnOne(results);
	}

	public numeric function objectCount()
	{
		return arrayLen(objects);
	}

	public array function getAllObjects()
	{
		return variables.objects;
	}

	private any function _returnOne(required array results)
	{
		if (arrayLen(results) == 0 ) {
			return _null();
		} else if (arrayLen(results) > 1) {
			throw(message="Expected only 1 result", errorCode="ObjectStore.TooManyMatches");
		} else {
			return results[1];
		}
	}

	private void function _loadDatabase() {
		if (fileExists(getDatabasePath())) {
			lock scope="application" type="exclusive" timeout="5" {
				var json = fileRead(getDatabasePath());
				variables.objects = deserializeJSON(json);
			}
			_indexObjects();
		} else if (getSeedPath() != "") {
			lock scope="application" type="exclusive" timeout="5" {
				json = fileRead(getSeedPath());
				variables.objects = deserializeJSON(json);
				// avoid deadlock
				if (getDatabasePath() != "") {
					fileWrite(getDatabasePath(), json);
				}
			}
		} else {
			variables.objects = [];
		}
	}

	private void function _saveDatabase() {
		if (getDatabasePath() == "") return;
		lock scope="application" type="exclusive" timeout="5" {
			trace("Saving database to #getDatabasePath()#");
			fileWrite(getDatabasePath(), serializeJSON(variables.objects));
		}
	}

	private void function _indexObjects () {
		lock name="objectAccess" type="exclusive" timeout="30" {
			variables.objectsById = {};
			for (var object in variables.objects) {
				if (NOT structKeyExists(object, "id")) {
					object['id'] = createUUID();
				}
				variables.objectsById[object.id] = object;
			}
		}
	}

	private any function _null () {
		return javaCast("null", 0);
	}

}