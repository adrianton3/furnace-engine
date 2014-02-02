define([
	'SystemBus',
	'Vec2',
	'Items'
	], function(
		SystemBus,
		Vec2,
		Items
	) {
	'use strict';

	function Player(world, spritesByName, tileDimensions, uiOffset) {
		this.world = world;
		this.blockWidth = tileDimensions.x;
		this.blockHeight = tileDimensions.y;
		this.uiOffset = uiOffset || new Vec2(0, 0);
		this.position = new Vec2(0, 0);
		this.sprite = null;
		this.spritesByName = spritesByName;
		this.direction = 'down';
	}

	var keyMapping = {
		65: 'use',
		83: 'invleft',
		68: 'invright',
		70: 'invmark',
		38: 'up',
		37: 'left',
		40: 'down',
		39: 'right'
	};

	var deltas = {
		up: new Vec2(0, -1),
		left: new Vec2(-1, 0),
		down: new Vec2(0, 1),
		right: new Vec2(1, 0)
	};

	var invDeltas = {
		invleft: -1,
		invright: 1
	};

	/**
	 * Initializes the player
	 */
	Player.prototype.init = function () {
		this.direction = 'down';
		this.sprite = this.spritesByName[this.direction];

		SystemBus.addListener('keydown', '', function(data) {
			if (data.key === 65) {
				this.use();
			} else if (data.key === 83 || data.key === 68) {
				this.world.inventory.move(invDeltas[keyMapping[data.key]]);
			} else {
				if (keyMapping[data.key]) {
					this.move(deltas[keyMapping[data.key]]);
					this.direction = keyMapping[data.key];
					this.sprite = this.spritesByName[this.direction];
				}
			}
		}.bind(this));
	};

	/**
	 * Sets the position of the player
	 */
	Player.prototype.setPosition = function (x, y) {
		this.position.x = x;
		this.position.y = y;
	};

	/**
	 * Leaves a location
	 */
	Player.prototype.leave = function () {
		var level = this.world.level;
		var ruleSet = this.world.leaveRuleSet;

		var currentTerrainItem = level.get(this.position.x, this.position.y);

		var rule = ruleSet.getRuleFor(currentTerrainItem.id);
		if (rule) {
			level.set(
				this.position.x,
				this.position.y,
				Items.collection[
					resolveItem(currentTerrainItem.id, -1, rule.outTerrainItem)]);
		}
	};

	/**
	 * Enters a new location
	 */
	Player.prototype.enter = function () {
		var inventory = this.world.inventory;
		var level = this.world.level;
		var ruleSet = this.world.enterRuleSet;

		var currentTerrainItem = level.get(this.position.x, this.position.y);

		var rule = ruleSet.getRuleFor(currentTerrainItem.id);
		if (rule) {
			level.set(
				this.position.x,
				this.position.y,
				Items.collection[
					resolveItem(currentTerrainItem.id, -1, rule.outTerrainItem)]);

			rule.outInventoryItems.forEach(function (item) {
				inventory.addItem(
					Items.collection[
						resolveItem(currentTerrainItem.id, -1, item.itemName)],
					item.quantity);
			});

			this.health += rule.healthDelta;
		}
	};

	/**
	 * Moves the delta units
	 */
	Player.prototype.move = function (delta) {
		var candidatePosition = this.position.add(delta);
		if (this.world.level.withinBounds(candidatePosition.x, candidatePosition.y)) {
			var futureBlock = this.world.level.get(candidatePosition.x, candidatePosition.y);
			if (!futureBlock.blocking) {
				this.leave();

				this.position = candidatePosition;
				this.world.camera.centerOn(this.position.x, this.position.y, this.world.level.width, this.world.level.height);

				this.enter();
			}
		}
	};

	/**
	 * Returns the facing position
	 */
	Player.prototype.getFacing = function () {
		return this.position.add(deltas[this.direction]);
	};

	function resolveItem(inTerrainItem, inInventoryItem, outItem) {
		if (outItem === '_terrain') {
			return inTerrainItem;
		} else if (outItem === '_inventory') {
			return inInventoryItem;
		} else {
			return outItem;
		}
	}

	/**
	 * Uses the current inventory item on the terrain unit that it's facing
	 */
	Player.prototype.use = function () {
		var inventory = this.world.inventory;
		var level = this.world.level;
		var ruleSet = this.world.useRuleSet;

		var currentInventoryItem = inventory.getCurrent();
		var facingPosition = this.getFacing();
		if (level.withinBounds(facingPosition.x, facingPosition.y)) {
			var currentTerrainItem = level.get(facingPosition.x, facingPosition.y);

			var rule = ruleSet.getRuleFor(currentTerrainItem.id, currentInventoryItem.id);
			if (rule) {
				if (!rule.consume ||
					(rule.consume &&
						inventory.has(
							Items.collection[
								resolveItem(currentTerrainItem.id, currentInventoryItem.id, currentInventoryItem.id)]))) {

					if (rule.consume) {
						inventory.consume(
							Items.collection[
								resolveItem(currentTerrainItem.id, currentInventoryItem.id, currentInventoryItem.id)]);
					}

					level.set(
						facingPosition.x,
						facingPosition.y,
						Items.collection[
							resolveItem(currentTerrainItem.id, currentInventoryItem.id, rule.outTerrainItem)]);

					rule.outInventoryItems.forEach(function (item) {
						inventory.addItem(
							Items.collection[
								resolveItem(currentTerrainItem.id, currentInventoryItem.id, item.itemName)],
							item.quantity);
					});

					this.health += rule.healthDelta;
				}
			}
		}
	};

	/**
	 * Draws the player
	 */
	Player.prototype.draw = function (camera, tick) {
		this.sprite.drawAt(
			this.uiOffset.x +
			(this.position.x - camera.position.x /*+ Math.floor(camera.dimensions.x / 2)*/) * this.blockWidth,
			this.uiOffset.y +
			(this.position.y - camera.position.y /*+ Math.floor(camera.dimensions.y / 2)*/) * this.blockHeight
		);
	};

	return Player;
});
