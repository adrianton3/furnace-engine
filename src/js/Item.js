define([], function() {
	'use strict';

	function Item(id, name, sprite, blocking) {
		this.id = id;
		this.name = name;
		this.sprite = sprite;
		this.blocking = blocking;
	}

	Item.prototype.drawAt = function(x, y) {
		this.sprite.drawAt(x, y);
	};

	return Item;
});
