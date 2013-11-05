(function () {

var req = new XMLHttpRequest();

req.open("GET", "/rest-example/index.cfm/lists", true);
req.setRequestHeader("Accept", "application/json");
req.onreadystatechange = function (state) {
	if (req.readyState === 4) {
		console.log(req.response);
	}
};

req.send();

})();