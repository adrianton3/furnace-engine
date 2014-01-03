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
		this.inventory = new Inventory(4, tileDimensions, new Vec2(0, 360));
		this.ruleSet = ruleSet;
		this.tileDimensions = tileDimensions;
	}

	World.prototype.init = function() {
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
		this.terrain.draw();
		this.inventory.draw();
		this.player.draw();
	};

	World.prototype.update = function() {

	};

	return World;
});
