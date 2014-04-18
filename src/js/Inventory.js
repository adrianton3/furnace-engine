define([
		'Items',
		'Text',
		'con2d',
		'Util',
        'underscore'
	], function (
		Items,
		Text,
		con2d,
		Util,
        _
	) {
	'use strict';

	function Inventory(sizeMax, tileDimensions, uiOffset) {
		this.sizeMax = sizeMax;
        this.sizeCurrent = 0;
		this.tileDimensions = tileDimensions;
		this.uiOffset = uiOffset;
		this.inventory = {};
		this.arrangement = [];
		this.current = 0;
        this.offset = 0;
	}

	/**
	 * Draw the inventory
	 */
	Inventory.prototype.draw = function () {
        // wrap this in a procedure
		con2d.fillStyle = '#000000';
		con2d.fillRect(
			this.uiOffset.x, this.uiOffset.y,
			this.sizeMax * this.tileDimensions.x, this.tileDimensions.y);

		for (var i = 0; i < this.sizeCurrent; i++) {
			// if null then skip
			var itemName = this.arrangement[(i + this.offset) % this.arrangement.length];
			var sprite = Items.collection[itemName];
			sprite.drawAt(
				this.uiOffset.x + i * this.tileDimensions.x,
				this.uiOffset.y
			);

			var text = '' + this.inventory[itemName];
			var offsetX = this.uiOffset.x + i * this.tileDimensions.x + this.tileDimensions.x - 4 - 16 * text.length;
			var offsetY = this.uiOffset.y + this.tileDimensions.y - 20;

			Text.drawAt(text, offsetX, offsetY);
		}

        if (this.empty()) { return; }
        // wrap this in a procedure
		con2d.lineWidth = 2;
		con2d.strokeStyle = '#FFF';
		con2d.strokeRect(
			this.uiOffset.x + (this.current - this.offset) * this.tileDimensions.x + 1, this.uiOffset.y + 1,
			this.tileDimensions.x - 2, this.tileDimensions.y - 2
		);
		con2d.strokeStyle = '#000';
		con2d.strokeRect(
			this.uiOffset.x + (this.current - this.offset) * this.tileDimensions.x + 2, this.uiOffset.y + 2,
			this.tileDimensions.x - 4, this.tileDimensions.y - 4
		);
	};

	/**
	 * Move the cursor left and right, changing the current inventory item
	 */
	Inventory.prototype.move = function (delta) {
        if (this.empty()) {
            this.current = 0;
            this.offset = 0;
            return;
        }

        this.current += delta;

        if (this.current < 0) {
            this.current = 0;
            this.offset = 0;
        } else if (this.current < this.offset) {
            this.offset = this.current;
        } else if (this.current >= this.arrangement.length) {
            this.current = this.arrangement.length - 1;
            this.offset = this.current - this.sizeCurrent + 1;
        } else if (this.current >= this.offset + this.sizeMax) {
            this.offset = this.current - this.sizeCurrent + 1;
        }
	};

    /**
     * Checks if the inventory is empty or not
     */
    Inventory.prototype.empty = function () {
        return this.arrangement.length === 0;
    };

    /**
	 * Checks if an item is present in the inventory
	 * @param {Item} item
	 */
	Inventory.prototype.has = function (item) {
		return !!this.inventory[item.id];
	};

	/**
	 * Consumes a specified item from the inventory
	 * @param {Item} item
	 */
	Inventory.prototype.consume = function (item) {
		this.inventory[item.id]--;
		if (!this.inventory[item.id]) {
			Util.remove(this.arrangement, item.id);
			if (this.current >= this.arrangement.length - this.offset - 1) {
				this.current--;
                this.offset = Math.max(this.offset - 1, 0);
			}
            this.sizeCurrent = Math.min(this.sizeMax, this.arrangement.length);
		}
	};

	/**
	 * Adds an item to the inventory
	 * @param {Item} item
 	 * @param {number} quantity
	 */
	Inventory.prototype.addItem = function (item, quantity) {
		if (typeof this.inventory[item.id] === 'number') {
			if (this.inventory[item.id] === 0) {
				this.arrangement.push(item.id);
			}
			this.inventory[item.id] += quantity;
		} else {
			this.inventory[item.id] = quantity;
			this.arrangement.push(item.id);
		}

        this.sizeCurrent = Math.min(this.sizeMax, this.arrangement.length);
	};

	/**
	 * Gets the current selected inventory item
	 */
	Inventory.prototype.getCurrent = function () {
		var itemName = this.arrangement[this.current];
		return Items.collection[itemName];
	};

    Inventory.prototype.serialize = function () {
        var inventory = _.clone(this.inventory);
        var arrangement = _.clone(this.arrangement);

        return {
            inventory: inventory,
            arrangement: arrangement,
            current: this.current
        };
    };

    Inventory.prototype.deserialize = function (config) {
        this.inventory = _.clone(config.inventory);
        this.arrangement = _.clone(config.arrangement);
        this.current = config.current;
    };

	return Inventory;
});
