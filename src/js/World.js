define([
	'Player',
	'Inventory',
	'Items',
	'Vec2',
    'rule/RuleSet',
	'con2d',
	'Camera',
    'TextBubble',
	'sound/Sound',
    'Util',
    'underscore'
	], function (
		Player,
		Inventory,
		Items,
		Vec2,
		RuleSet,
		con2d,
		Camera,
		TextBubble,
		Sound,
		Util,
		_
	) {
	'use strict';

	const frameTime = 120

	function World(
		playerSpritesByName,
		levelsByName,
		startLocation,
		nearRuleSet,
		leaveRuleSet,
		enterRuleSet,
		useRuleSet,
		tileDimensions,
		cameraDimensions,
		inventorySizeMax,
		playerMaxHealth,
		sounds
		) {
		this.player = new Player(this, playerMaxHealth, playerSpritesByName, tileDimensions);
		this.startLocation = startLocation;
		this.levelsByName = levelsByName;
		this.level = null;
        this.nearRuleSet = nearRuleSet;
		this.leaveRuleSet = leaveRuleSet;
		this.enterRuleSet = enterRuleSet;
		this.useRuleSet = useRuleSet;
		this.tileDimensions = tileDimensions;
		this.sounds = sounds;

		this.camera = new Camera(new Vec2(0, 0), new Vec2(cameraDimensions.x, cameraDimensions.y));

		this.inventory = new Inventory(
			inventorySizeMax,
			tileDimensions,
			new Vec2(0, this.tileDimensions.y * this.camera.dimensions.y + 8)
		);

        this.textBubble = new TextBubble().hide();

        // animation related
		this.tick = 0;
		this.subTick = 0;
	}

	World.prototype.init = function () {
		con2d.canvas.width = this.tileDimensions.x * this.camera.dimensions.x; //this.levelsByName.entry.width;
		con2d.canvas.height = this.tileDimensions.y * (this.camera.dimensions.y + 1) + 8; //(this.levelsByName.entry.height + 1) + 8;

		this.player.init();
		this.initStartingLocation();

		con2d.fillStyle = '#000';
		con2d.fillRect(0, 0, con2d.canvas.width, con2d.canvas.height);

		this.camera.centerOn(this.player.position.x, this.player.position.y, this.level.width, this.level.height);

        this.initialState = this.serialize();
	};

	World.prototype.setLevel = function (levelName) {
		this.level = this.levelsByName[levelName];
	};

	World.prototype.initStartingLocation = function () {
		this.level = this.levelsByName[this.startLocation.levelName];
		this.player.setPosition(this.startLocation.x, this.startLocation.y);
	};

	World.prototype.playSound = function (id) {
		var sound = this.sounds[id];
		Sound.play(sound);
	};

	World.prototype.draw = function () {
        if (this.player.alive) {
            this.level.draw(this.camera, this.tick);
            this.inventory.draw();
            this.player.draw(this.camera, this.tick);
        } else {
            con2d.fillStyle = '#000';
            con2d.fillRect(0, 0, con2d.canvas.width, con2d.canvas.height);
        }
        this.textBubble.draw();
	};

	World.prototype.update = function () {
		const now = performance.now()
		if (now - this.updateTime < frameTime) {
			return
		}

		this.updateTime = now

		this.subTick++
		if (this.subTick >= 5) {
			this.subTick = 0
			this.tick = 1 - this.tick
		}

		this.player.update()
	};

    World.prototype.serialize = function () {
        var levels = Util.mapOnKeys(this.levelsByName, function (level) {
            return level.serialize();
        });

        var currentLevel = this.level.id;

        return {
            player: this.player.serialize(),
            inventory: this.inventory.serialize(),
            levels: levels,
            currentLevel: currentLevel
        };
    };

    World.prototype.deserialize = function (config) {
        _.each(config.levels, function (levelConfig, key) {
            this.levelsByName[key].deserialize(levelConfig);
        }.bind(this));

        this.setLevel(config.currentLevel);

        this.player.deserialize(config.player);

        this.inventory.deserialize(config.inventory);
    };

	return World;
});
