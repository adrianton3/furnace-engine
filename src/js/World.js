define([
	'Player',
	'Inventory',
	'Items',
	'Vec2',
	'rule/RuleSet',
	'rule/LeaveRule',
	'rule/EnterRule',
	'rule/UseRule',
	'con2d',
	'Camera'
	], function (
		Player,
		Inventory,
		Items,
		Vec2,
		RuleSet,
		LeaveRule,
		EnterRule,
		UseRule,
		con2d,
		Camera
	) {
	'use strict';

	function World(
		playerSpritesByName,
		levelsByName,
		startLocation,
		leaveRuleSet,
		enterRuleSet,
		useRuleSet,
		tileDimensions
		) {
		this.player = new Player(this, playerSpritesByName, tileDimensions);
		this.startLocation = startLocation;
		this.levelsByName = levelsByName;
		this.level = null;
		this.leaveRuleSet = leaveRuleSet;
		this.enterRuleSet = enterRuleSet;
		this.useRuleSet = useRuleSet;
		this.tileDimensions = tileDimensions;

		this.camera = new Camera(new Vec2(0, 0), new Vec2(7, 7));

		this.inventory = new Inventory(
			4,
			tileDimensions,
			new Vec2(0, this.tileDimensions.y * this.camera.dimensions.y + 8)
		);

		// adding an initial item in the inventory with which you obtain the rest of the items
		this.inventory.addItem(Items.collection.pickaxe, 9);

		this.tick = 0;
		this.z = 0;
	}

	World.prototype.init = function () {
		con2d.canvas.width = this.tileDimensions.x * this.camera.dimensions.x; //this.levelsByName.entry.width;
		con2d.canvas.height = this.tileDimensions.y * (this.camera.dimensions.y + 1) + 8; //(this.levelsByName.entry.height + 1) + 8;

		this.player.init();
		this.initStartingLocation();

		con2d.fillStyle = '#000';
		con2d.fillRect(0, 0, con2d.canvas.width, con2d.canvas.height);

		this.camera.centerOn(this.player.position.x, this.player.position.y, this.level.width, this.level.height);
	};

	World.prototype.setLevel = function (levelName) {
		this.level = this.levelsByName[levelName];
	};

	World.prototype.initStartingLocation = function () {
		this.level = this.levelsByName[this.startLocation.levelName];
		this.player.setPosition(this.startLocation.x, this.startLocation.y);
	};

	World.prototype.draw = function () {
		this.level.draw(this.camera, this.tick);
		this.inventory.draw();
		this.player.draw(this.camera, this.tick);
	};

	World.prototype.update = function () {
		this.z++; // should count deltaTime
		if (this.z >= 20) {
			this.z = 0;
			this.tick = 1 - this.tick;
		}
	};

	return World;
});
