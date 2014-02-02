define([
		'Items',
		'Text',
		'con2d',
		'Util'
	], function (
		Items,
		Text,
		con2d,
		Util
	) {
	'use strict';

	function Inventory(sizeMax, tileDimensions, uiOffset) {
		this.sizeMax = sizeMax; // unused
		this.tileDimensions = tileDimensions;
		this.uiOffset = uiOffset;
		this.inventory = {};
		this.arrangement = [];
		this.current = 0;
	}

	/**
	 * Draw the inventory
	 */
	Inventory.prototype.draw = function() {
		con2d.fillStyle = '#000000';
		con2d.fillRect(
			this.uiOffset.x, this.uiOffset.y,
			(this.arrangement.length + 1) * this.tileDimensions.x, this.tileDimensions.y);

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
				this.uiOffset.x + 22 + i * this.tileDimensions.x,
				this.uiOffset.y + 20
			);
		}

		con2d.lineWidth = 2;
		con2d.strokeStyle = '#FFF';
		con2d.strokeRect(
			this.uiOffset.x + this.current * this.tileDimensions.x + 1, this.uiOffset.y + 1,
			this.tileDimensions.x - 2, this.tileDimensions.y - 2
		);
		con2d.strokeStyle = '#000';
		con2d.strokeRect(
			this.uiOffset.x + this.current * this.tileDimensions.x + 2, this.uiOffset.y + 2,
			this.tileDimensions.x - 4, this.tileDimensions.y - 4
		);
	};

	/**
	 * Move the cursor left and right, changing the current inventory item
	 */
	Inventory.prototype.move = function(delta) {
		this.current += delta + this.arrangement.length;
		this.current %= this.arrangement.length;
	};

	/**
	 * Checks if an item is present in the inventory
	 * @param {Item} item
	 */
	Inventory.prototype.has = function(item) {
		return !!this.inventory[item.id];
	};

	/**
	 * Consumes a specified item from the inventory
	 * @param {Item} item
	 */
	Inventory.prototype.consume = function(item) {
		this.inventory[item.id]--;
		if (!this.inventory[item.id]) {
			Util.remove(this.arrangement, item.id);
			if (this.current === this.arrangement.length) {
				this.current--;
			}
		}
	};

	/**
	 * Adds an item in the inventory
	 * @param {Item} item
 	 * @param {number} quantity
	 */
	Inventory.prototype.addItem = function(item, quantity) {
		if (typeof this.inventory[item.id] === 'number') {
			if (this.inventory[item.id] === 0) {
				this.arrangement.push(item.id);
			}
			this.inventory[item.id] += quantity;
		} else {
			this.inventory[item.id] = quantity;
			this.arrangement.push(item.id);
		}
	};

	/**
	 * Gets the current selected inventory item
	 */
	Inventory.prototype.getCurrent = function() {
		var itemName = this.arrangement[this.current];
		return Items.collection[itemName];
	};

	return Inventory;
});
