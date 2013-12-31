define([
		'Items',
		'Text',
		'con2d'
	], function (
		Items,
		Text,
		con2d
	) {
	'use strict';

	function Inventory(size, tileDimensions, uiOffset) {
		this.size = size;
		this.tileDimensions = tileDimensions;
		this.uiOffset = uiOffset;
		this.inventory = { // should populate this as items are added
			'grass': 0,
			'dirt': 0,
			'stone': 0,
			'pickaxe': 0
		};
		this.arrangement = ['grass', 'dirt', 'stone', 'pickaxe']; // should be nulls at first
		this.current = 0;
	}

	Inventory.prototype.draw = function() {
		var blockWidth = 32;

		for (var i = 0; i < this.arrangement.length; i++) {
			// if null then skip
			var itemName = this.arrangement[i];
			var sprite = Items.collection[itemName];
			sprite.drawAt(
				this.uiOffset.x + i * this.tileDimensions.x,
				this.uiOffset.y
			);
			Text.drawAt(
				this.inventory[itemName],
				this.uiOffset.x + 24 + i * this.tileDimensions.x,
				this.uiOffset.y + 22
			);
		}

		con2d.lineWidth = 2;
		con2d.strokeStyle = '#000';
		con2d.strokeRect(
			this.uiOffset.x + this.current * this.tileDimensions.x + 1, this.uiOffset.y + 1,
			this.tileDimensions.x - 2, this.tileDimensions.y - 2
		);
		con2d.strokeStyle = '#FFF';
		con2d.strokeRect(
			this.uiOffset.x + this.current * this.tileDimensions.x + 2, this.uiOffset.y + 2,
			this.tileDimensions.x - 4, this.tileDimensions.y - 4
		);
	};

	Inventory.prototype.move = function(delta) {
		this.current += delta + this.arrangement.length;
		this.current %= this.arrangement.length;
	};

	Inventory.prototype.consume = function(item) {
		this.inventory[item.id]--;
		// replace with null when reaches 0
	};

	Inventory.prototype.addItem = function(item, quantity) {
		this.inventory[item.id] += quantity;
		// add if new
	};

	Inventory.prototype.getCurrent = function() {
		var itemName = this.arrangement[this.current];
		return Items.collection[itemName];
	};

	return Inventory;
});
