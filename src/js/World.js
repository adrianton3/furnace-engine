define([
	'Player',
	'Inventory',
	'Items',
	'Vec2',
	'RuleSet',
	'Rule',
	'con2d'
	], function (
		Player,
		Inventory,
		Items,
		Vec2,
		RuleSet,
		Rule,
		con2d
	) {
	'use strict';

	function World(playerSpritesByName, levelsByName, startLocation, ruleSet, tileDimensions) {
		this.player = new Player(this, playerSpritesByName, tileDimensions);
		this.startLocation = startLocation;
		this.levelsByName = levelsByName;
		this.terrain = null; // level
		this.ruleSet = ruleSet;
		this.tileDimensions = tileDimensions;
		this.inventory = new Inventory(
			4,
			tileDimensions,
			new Vec2(0, this.tileDimensions.y * this.levelsByName.entry.height + 8)
		);
		this.tick = 0;
		this.z = 0;
	}

	World.prototype.init = function() {
		con2d.canvas.width = this.tileDimensions.x * this.levelsByName.entry.width;
		con2d.canvas.height = this.tileDimensions.y * (this.levelsByName.entry.height + 1) + 8;

		this.player.init();
		this.initStartingLocation();

		con2d.fillStyle = '#000';
		con2d.fillRect(0, 0, con2d.canvas.width, con2d.canvas.height);
	};

	World.prototype.initStartingLocation = function() {
		this.terrain = this.levelsByName[this.startLocation.levelName];
		this.player.setPosition(this.startLocation.x, this.startLocation.y);
	};

	World.prototype.draw = function() {
		this.terrain.draw(this.tick);
		this.inventory.draw();
		this.player.draw(this.tick);
	};

	World.prototype.update = function() {
		this.z++;
		if (this.z >= 20) {
			this.z = 0;
			this.tick = 1 - this.tick;
		}
	};

	return World;
});
