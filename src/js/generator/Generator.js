define([
	'generator/SpriteSheetGenerator',
	'Util',
	'World',
	'Item',
	'Items',
	'Set',
    'rule/NearRule',
	'rule/LeaveRule',
	'rule/EnterRule',
	'rule/UseRule',
	'rule/RuleSet',
	'Vec2',
	'Level'
	], function (
		SpriteSheetGenerator,
		Util,
		World,
		Item,
		Items,
		Set,
        NearRule,
		LeaveRule,
		EnterRule,
		UseRule,
		RuleSet,
		Vec2,
		Level
	) {
	'use strict';

	var Generator = {};

	Generator.generate = function (spec) {
		var params = Generator.generate.params(spec.params, spec.levels);

		var playerSpritesByName = Generator.generate.player(spec.player, spec.colors, params.scale);

		var itemsByName = Generator.generate.objects(spec.objects, spec.colors, params.scale);
		Items.collection = itemsByName;

		var setsByName = Generator.generate.sets(spec.sets);
        var nearRuleSet = Generator.generate.nearRules(spec.nearRules, setsByName);
		var leaveRuleSet = Generator.generate.leaveRules(spec.leaveRules, setsByName);
		var enterRuleSet = Generator.generate.enterRules(spec.enterRules, setsByName);
		var useRuleSet = Generator.generate.useRules(spec.useRules, setsByName);

		// sort of hacky
		var tileDimensions = playerSpritesByName.left.end.sub(playerSpritesByName.left.start);

		var levelsByName = Generator.generate.levels(spec.levels, spec.legend, tileDimensions);

		var world = new World(
			playerSpritesByName,
			levelsByName,
			params.startLocation,
            nearRuleSet,
			leaveRuleSet,
			enterRuleSet,
			useRuleSet,
			tileDimensions,
			params.camera
		);

		return world;
	};

	Generator.generate.params = function (paramSpec, levelsSpec) {
		// needs rewriting using some variant of deepExend
		return {
			camera: {
				x: +paramSpec.camera[0].s || 7,
				y: +paramSpec.camera[1].s || 7
			},
			scale: +paramSpec.scale[0].s || 8,
			startLocation: {
				x: +paramSpec.start_location[0].s || 2,
				y: +paramSpec.start_location[1].s || 2,
				levelName: paramSpec.start_location[2].s || (levelsByName.entry ? 'entry' : Object.keys(levelsByName)[0])
			}
		};
	};

	Generator.generate.player = function (playerSpec, colorSpec, scale) {
		var namedPlayerSprites = SpriteSheetGenerator.generate(playerSpec, colorSpec, scale);
		var playerSpritesByName = Util.arrayToObject(namedPlayerSprites, 'name', 'sprite');
		return playerSpritesByName;
	};

	Generator.generate.objects = function (objectsSpec, colorSpec, scale) {
		var stringedObjects = Util.mapOnKeys(objectsSpec, function(object) {
			return object.lines;
		});
		var namedSprites = SpriteSheetGenerator.generate(stringedObjects, colorSpec, scale);

		function processSpriteName(nam) {
			var separator = nam.lastIndexOf(':');
			if (separator === -1) {
				return {
					name: nam,
					frame: 0
				};
			} else {
				return {
					name: nam.substr(0, separator),
					frame: +nam.substr(separator + 1)
				};
			}
		}

		var groupedSprites = Util.groupBy(namedSprites, function (namedSprite) {
			var frameAndName = processSpriteName(namedSprite.name);
			return frameAndName.name;
		});

		var namedSpriteGroups = Util.objectToArray(groupedSprites, 'groupName', 'namedSprites');

		var itemsByName = {};

		namedSpriteGroups.forEach(function (namedSpriteGroup) {
			var sortedSprites = namedSpriteGroup.namedSprites.map(function (namedSprite) {
				var nameAndFrame = processSpriteName(namedSprite.name);
				return {
					sprite: namedSprite.sprite,
					name: nameAndFrame.name,
					frame: nameAndFrame.frame
				};
			}).sort(function (a, b) {
				return a.frame - b.frame;
			});

			var sprites = sortedSprites.map(function (namedSprite) {
				return namedSprite.sprite;
			});

			itemsByName[namedSpriteGroup.groupName] = new Item(
				namedSpriteGroup.groupName,
				Util.capitalize(namedSpriteGroup.groupName),
				sprites,
				objectsSpec[namedSpriteGroup.groupName].blocking
			);
		});

		return itemsByName;
	};

	Generator.generate.sets = function(spec) {
		var ops = {
			'or': Set.prototype.union,
			'and': Set.prototype.intersection,
			'minus': Set.prototype.difference
		};

		var setsByName = {};

		spec.forEach(function(setDefinition) {
			var set;

			if (setDefinition.elements) {
				set = new Set();

				setDefinition.elements.forEach(function (element) {
					set.add(element);
				});
			} else {
				var operand1 = setsByName[setDefinition.operand1.s];
				var operand2 = setsByName[setDefinition.operand2.s];
				var operator = ops[setDefinition.operator.s];

				set = operator.call(operand1, operand2);
			}

			setsByName[setDefinition.name] = set;
		});

		return setsByName;
	};

    Generator.generate.nearRules = function(rulesSpec, setsByName) {
        var rules = rulesSpec.map(function (ruleSpec) {
            var inTerrainItemName = ruleSpec.inTerrainItemName.s;
            var outTerrainItemName = ruleSpec.outTerrainItemName.s;

            var healthDelta = 0;
            if (ruleSpec.heal) {
                healthDelta += +ruleSpec.heal.s;
            }
            if (ruleSpec.hurt) {
                healthDelta -= +ruleSpec.hurt.s;
            }

            return new NearRule(
                inTerrainItemName,
                outTerrainItemName,
                healthDelta
            );
        });

        return new RuleSet(rules, setsByName);
    };

	Generator.generate.leaveRules = function(rulesSpec, setsByName) {
		var rules = rulesSpec.map(function (ruleSpec) {
			var inTerrainItemName = ruleSpec.inTerrainItemName.s;
			var outTerrainItemName = ruleSpec.outTerrainItemName.s;

			return new LeaveRule(
				inTerrainItemName,
				outTerrainItemName
			);
		});

		return new RuleSet(rules, setsByName);
	};

	Generator.generate.enterRules = function(rulesSpec, setsByName) {
		var rules = rulesSpec.map(function (ruleSpec) {
			var inTerrainItemName = ruleSpec.inTerrainItemName.s;
			var outTerrainItemName = ruleSpec.outTerrainItemName.s;

			// some don't give back anything
			var outInventoryItems;

			if (ruleSpec.give) {
				outInventoryItems = ruleSpec.give.map(function (entry) {
					return {
						itemName: entry.itemName.s,
						quantity: +entry.quantity.s
					};
				});
			} else {
				outInventoryItems = [];
			}

			var healthDelta = 0;
			if (ruleSpec.heal) {
				healthDelta += +ruleSpec.heal.s;
			}
			if (ruleSpec.hurt) {
				healthDelta -= +ruleSpec.hurt.s;
			}

			var teleport;

			if (ruleSpec.teleport) {
				teleport = {
					x: +ruleSpec.teleport.x.s,
					y: +ruleSpec.teleport.y.s,
					levelName: ruleSpec.teleport.levelName.s
				};
			}

			var message;
			if (ruleSpec.message) {
				message = ruleSpec.message.s;
			}

			return new EnterRule(
				inTerrainItemName,
				outTerrainItemName,
				outInventoryItems,
				healthDelta,
				teleport,
				message,
                ruleSpec.checkpoint
			);
		});

		return new RuleSet(rules, setsByName);
	};

	Generator.generate.useRules = function(rulesSpec, setsByName) {
		var rules = rulesSpec.map(function (ruleSpec) {
			var inTerrainItemName = ruleSpec.inTerrainItemName.s;
			var inInventoryItemName = ruleSpec.inInventoryItemName.s;
			var outTerrainItemName = ruleSpec.outTerrainItemName.s;

			// some don't give back anything
			var outInventoryItems;

			if (ruleSpec.give) {
				outInventoryItems = ruleSpec.give.map(function (entry) {
					return {
						itemName: entry.itemName.s,
						quantity: +entry.quantity.s
					};
				});
			} else {
				outInventoryItems = [];
			}

			var consume = !!ruleSpec.consume;

			var healthDelta = 0;
			if (ruleSpec.heal) {
				healthDelta += +ruleSpec.heal.s;
			}
			if (ruleSpec.hurt) {
				healthDelta -= +ruleSpec.hurt.s;
			}

			var teleport;

			if (ruleSpec.teleport) {
				teleport = {
					x: +ruleSpec.teleport.x.s,
					y: +ruleSpec.teleport.y.s,
					levelName: ruleSpec.teleport.levelName.s
				};
			}

			var message;
			if (ruleSpec.message) {
				message = ruleSpec.message.s;
			}

			return new UseRule(
				inTerrainItemName,
				inInventoryItemName,
				outTerrainItemName,
				outInventoryItems,
				consume,
				healthDelta,
				teleport,
				message
			);
		});

		return new RuleSet(rules, setsByName);
	};

	Generator.generate.levels = function(levelsSpec, legendSpec, tileDimensions) {
		var levelsByName = {};

		var namedStringedLevels = Util.objectToArray(levelsSpec, 'levelName', 'lines');

		namedStringedLevels.forEach(function (namedStringedLevel) {
			var data = namedStringedLevel.lines.map(function (line) {
				return line.s.split('').map(function (char) {
					var itemName = legendSpec[char];
					return Items.collection[itemName];
				});
			});

			var levelDimensions = new Vec2(data[0].length, data.length);

			levelsByName[namedStringedLevel.levelName] = new Level(namedStringedLevel.levelName, data, levelDimensions, tileDimensions);
		});

		return levelsByName;
	};

	return Generator;
});
