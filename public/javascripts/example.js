(function () {
	var selectedList = null;
	var lists = {};
	var items = {};

	var renderItem = function (item) {
		var icon = item.complete ? 'glyphicon-check' : 'glyphicon-unchecked';
		return "<li data-item-id='" + item.id + "''><span class='glyphicon " + icon + "'></span> " + item.label + "</li>";
	};

	var listItemClickHandler = function (event) {
		var $this = $(this);
		var itemId = $this.data('item-id');
		$.post('/rest-example/index.cfm/lists/' + selectedList.id + '/items/' + itemId + '?_method=PUT',
			{complete: !items[itemId].complete}).done(function (data) {
				items[itemId] = data;
				$this.html(renderItem(data));
		});
	};

	var listClickHandler = function (event) {
		event.preventDefault();
		var listId = $(this).data('list-id');
		selectedList = lists[listId];
		$(".list-name").html(selectedList.name);
		$.get('/rest-example/index.cfm/lists/' + listId + '/items').done(function (data) {
			var html = "";
			data.forEach(function (item) {
				item.complete = (item.complete === "true");
				items[item.id] = item;
				html += renderItem(item);
			});
			$(".list-items").html(html).find("li").click(listItemClickHandler);
		});
	};

	$.get("/rest-example/index.cfm/lists").done(function (listData) {
		listData.forEach(function (list) {
			lists[list.id] = list;
			$(".lists").append("<li><a href='#' data-list-id='" + list.id + "' class='list'>" + list.name + "</a></li>");
			$(".loading").hide();
			$(".list").click(listClickHandler);
		});
	});
})();