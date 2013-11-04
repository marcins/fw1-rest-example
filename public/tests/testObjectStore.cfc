component extends="mxunit.framework.TestCase" {
	public void function setUp () {
		variables.objectStore = new app.model.services.objectStore("");
	}

	public void function testEmptyStore () {
		assertEquals(0, objectStore.objectCount());
		assertEquals({}, objectStore.getObjectById("doesn't exist"));
	}

	public void function testBasicAddRetrieve () {
		var obj = {
			name: "Bob",
			id: createUUID()
		};
		objectStore.setObject(obj);
		assertEquals(1, objectStore.objectCount());
		var retrievedObj = objectStore.getObjectById(obj.id);
		assertEquals(retrievedObj, obj);
	}

	public void function testRetrieveByProperty () {
		var objects = [
			{name: "Bob", type: "Person"},
			{name: "Jane", type: "Person"},
			{name: "Foo", type: "Other"}
		];

		for (var object in objects) {
			objectStore.setObject(object);
		}
		var objs = objectStore.getObjectsByProperty("type", "Person");
		assertEquals(2, objs.len());
	}

	public void function testNoResultObjectFilterFunction () {
		var objs = objectStore.getObjectByFilterFunction(function (object) {
			return false;
		});
		assertTrue(isNull(objs), "objs should be null");
	}

	public void function testObjectFilterFunction () {
		var objects = [
			{id: 1, name: "Bob", type: "Person"},
			{id: 2, name: "Jane", type: "Person"},
			{id: 3, name: "Foo", type: "Other"}
		];

		for (var object in objects) {
			objectStore.setObject(object);
		}
		var objs = objectStore.getObjectsByFilterFunction(function (object) {
			return object.name == "Bob" && object.type == "Person";
		});
		assertEquals(1, objs.len());
		assertEquals(1, objs[1].id);
	}

	public void function testReplaceObject () {
		var object = {id: 1, name: "Bob", type: "Person"};
		objectStore.setObject(object);
		assertEquals(1, objectStore.objectCount());
		object.name = "Jane";
		objectStore.setObject(object);
		assertEquals(1, objectStore.objectCount());
		var retrievedObj = objectStore.getObjectById(1);
		assertEquals("Jane", retrievedObj.name);
	}

	public void function testReplaceObjectGeneratedId () {
		var object = {name: "Bob", type: "Person"};
		objectStore.setObject(object);
		assertEquals(1, objectStore.objectCount());
		object.name = "Jane";
		objectStore.setObject(object);
		assertEquals(1, objectStore.objectCount());
		var retrievedObj = objectStore.getObjectByProperty("name", "Jane");
		assertFalse(isNull(retrievedObj));
		assertEquals("Jane", retrievedObj.name);
	}
}