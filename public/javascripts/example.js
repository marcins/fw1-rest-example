(function () {

$.get("/rest-example/index.cfm/lists").done(function (lists) {
	lists.forEach(function (list) {
		$(".lists").append("<li><a href='#' data-list-id='" + list.id + "' class='list'>" + list.name + "</a></li>");
		$(".loading").hide();
		$(".list").click(function (event) {
			event.preventDefault();
			var listId = $(this).data('list-id');
			$.get('/rest-example/index.cfm/lists/' + listId).done(function (data) {
				$(".list-name").html(data.list.name);
				var html = "";
				data.listItems.forEach(function (item) {
					var icon = item.complete ? 'glyphicon-check' : 'glyphicon-unchecked';
					html += "<li><span class='glyphicon " + icon + "'></span> " + item.label + "</li>";
				});
				$(".list-items").html(html);
			});
		});
	});
});

})();