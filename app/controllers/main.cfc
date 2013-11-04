component output="false" displayname="" accessors="true"  {

	property name="objectStoreService";

	public function init(required any fw){
		variables.fw = fw;
		return this;
	}

	public void function default (required any rc) {
	}

}