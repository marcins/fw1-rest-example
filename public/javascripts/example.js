(function () {
	var selectedList = null;
	var listsById = {};
	var lists = [];

	var $lists = $(".lists");
	var $listItems = $('.list-items');

	var renderItemElem = function (item) {
		var icon = item.complete ? 'glyphicon-check' : 'glyphicon-unchecked';
		return "<li data-item-id='" + item.id + "' class='list-item'><span class='glyphicon " + icon + "'></span> " + item.label + "</li>";
	};

	var renderListElem = function (list) {
		return "<li><a href='#' data-list-id='" + list.id + "' class='list'>" + list.name + "<span class='badge pull-right'>" + (list.itemCount || 0) + "</span></a></li>";
	};

	var renderLists = function () {
		lists.sort(function (a, b) {
			if (a.name.toLowerCase() > b.name.toLowerCase()) {
				return 1;
			} else if (a.name.toLowerCase() < b.name.toLowerCase()) {
				return - 1;
			} else {
				return 0;
			}
		});
		$lists.find("li").remove();
		var html = [];
		lists.forEach(function (list) {
			listsById[list.id] = list;
			html.push(renderListElem(list));
		});
		$lists.html(html.join("\n"));
	};

	var renderList = function () {
		var html = [];
		for (var itemId in selectedList.items) {
			if (selectedList.items.hasOwnProperty(itemId)) {
				var item = selectedList.items[itemId];
				html.push(renderItemElem(item));
			}
		}
		$listItems.find('li').remove();
		$listItems.html(html.join("\n"));
		$(".list-detail").show();
	};

	$(".btn-add-list").click(function () {
		var listName = $("#new-list-name").val();
		if (listName !== "") {
			$.post(Example.baseUrl + '/lists', {name: listName}).done(function (list) {
				lists.push(list);
				renderLists();
			});
		}
	});

	$(".btn-add-item").click(function () {
		var itemLabel = $("#new-item-label").val();
		if (itemLabel !== "") {
			$.post(Example.baseUrl + '/lists/' + selectedList.id + '/items',
				{label: itemLabel}).done(function(item) {
				selectedList.items[item.id] = item;
				renderList();
			});
		}
	});

	$(".btn-delete-list").click(function () {
		$.ajax(Example.baseUrl + '/lists/' + selectedList.id, {type: "DELETE"}).done(function (listData) {
			$(".list-detail").hide();
			lists = listData;
			renderLists();
		});
	});

	var listItemClickHandler = function (event) {
		var $this = $(this);
		var itemId = $this.data('item-id');
		$.ajax(Example.baseUrl + '/lists/' + selectedList.id + '/items/' + itemId, {
				type: "PUT",
				data: {complete: !selectedList.items[itemId].complete}
			}).done(function (data) {
				selectedList.items[itemId] = data;
				renderList();
		});
	};

	var listClickHandler = function (event) {
		event.preventDefault();
		var listId = $(this).data('list-id');
		selectedList = listsById[listId];
		$(".list-name").html(selectedList.name);
		$.get(Example.baseUrl + '/lists/' + listId + '/items').done(function (data) {
			selectedList.items = {};
			data.forEach(function (item) {
				selectedList.items[item.id] = item;
			});
			renderList();
		});
	};

	$lists.on('click', '.list', listClickHandler);
	$listItems.on('click', '.list-item', listItemClickHandler);

	$(function () {
		$.get(Example.baseUrl + "/lists").done(function (listData) {
			lists = listData;
			renderLists();
			$(".loading").hide();
		});
	});
})();