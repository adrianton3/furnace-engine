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
			params.camera,
            params.inventorySizeMax,
            params.healthMax
		);

		return world;
	};

	Generator.generate.params = function (params, levelsSpec) {
		// needs rewriting using some variant of deepExend
		var paramSpec = Util.arrayToObject(params, 'name', 'parts');

		return {
			camera: {
				x: +paramSpec.camera[0] || 7,
				y: +paramSpec.camera[1] || 7
			},
			scale: +paramSpec.scale[0] || 8,
			startLocation: {
				x: +paramSpec.start_location[0] || 2,
				y: +paramSpec.start_location[1] || 2,
				levelName: paramSpec.start_location[2] || (levelsByName.entry ? 'entry' : Object.keys(levelsByName)[0])
			},
            inventorySizeMax: +paramSpec.inventory_size_max[0] || 5,
            healthMax: +paramSpec.health_max[0]
		};
	};

	Generator.generate.player = function (playerSpec, colorSpec, scale) {
		var namedPlayerSprites = SpriteSheetGenerator.generate(playerSpec, colorSpec, scale);
		var playerSpritesByName = Util.arrayToObject(namedPlayerSprites, 'name', 'sprite');
		return playerSpritesByName;
	};

	Generator.generate.objects = function (objectsSpec, colorSpec, scale) {
		var namedSprites = SpriteSheetGenerator.generate(objectsSpec, colorSpec, scale);

		var blockingObjects = {};
		objectsSpec.forEach(function (objectSpec) {
			if (objectSpec.blocking) {
				blockingObjects[objectSpec.name] = true;
			}
		});

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
				!!blockingObjects[namedSpriteGroup.groupName]
			);
		});

		return itemsByName;
	};

	Generator.generate.sets = function (spec) {
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
				var operand1 = setsByName[setDefinition.operand1];
				var operand2 = setsByName[setDefinition.operand2];
				var operator = ops[setDefinition.operator];

				set = operator.call(operand1, operand2);
			}

			setsByName[setDefinition.name] = set;
		});

		return setsByName;
	};

    Generator.generate.nearRules = function (rulesSpec, setsByName) {
        var rules = rulesSpec.map(function (ruleSpec) {
            var inTerrainItemName = ruleSpec.inTerrainItemName;
            var outTerrainItemName = ruleSpec.outTerrainItemName;

            var healthDelta = 0;
            if (ruleSpec.heal) {
                healthDelta += +ruleSpec.heal;
            }
            if (ruleSpec.hurt) {
                healthDelta -= +ruleSpec.hurt;
            }

            return new NearRule(
                inTerrainItemName,
                outTerrainItemName,
                healthDelta
            );
        });

        return new RuleSet(rules, setsByName);
    };

	Generator.generate.leaveRules = function (rulesSpec, setsByName) {
		var rules = rulesSpec.map(function (ruleSpec) {
			var inTerrainItemName = ruleSpec.inTerrainItemName;
			var outTerrainItemName = ruleSpec.outTerrainItemName;

			return new LeaveRule(
				inTerrainItemName,
				outTerrainItemName
			);
		});

		return new RuleSet(rules, setsByName);
	};

	Generator.generate.enterRules = function (rulesSpec, setsByName) {
		var rules = rulesSpec.map(function (ruleSpec) {
			var inTerrainItemName = ruleSpec.inTerrainItemName;
			var outTerrainItemName = ruleSpec.outTerrainItemName;

			// some don't give back anything
			var outInventoryItems;

			if (ruleSpec.give) {
				outInventoryItems = ruleSpec.give.map(function (entry) {
					return {
						itemName: entry.itemName,
						quantity: +entry.quantity
					};
				});
			} else {
				outInventoryItems = [];
			}

			var healthDelta = 0;
			if (ruleSpec.heal) {
				healthDelta += +ruleSpec.heal;
			}
			if (ruleSpec.hurt) {
				healthDelta -= +ruleSpec.hurt;
			}

			var teleport;

			if (ruleSpec.teleport) {
				teleport = {
					x: +ruleSpec.teleport.x,
					y: +ruleSpec.teleport.y,
					levelName: ruleSpec.teleport.levelName
				};
			}

			var message;
			if (ruleSpec.message) {
				message = ruleSpec.message;
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

	Generator.generate.useRules = function (rulesSpec, setsByName) {
		var rules = rulesSpec.map(function (ruleSpec) {
			var inTerrainItemName = ruleSpec.inTerrainItemName;
			var inInventoryItemName = ruleSpec.inInventoryItemName;
			var outTerrainItemName = ruleSpec.outTerrainItemName;

			// some don't give back anything
			var outInventoryItems;

			if (ruleSpec.give) {
				outInventoryItems = ruleSpec.give.map(function (entry) {
					return {
						itemName: entry.itemName,
						quantity: +entry.quantity
					};
				});
			} else {
				outInventoryItems = [];
			}

			var consume = !!ruleSpec.consume;

			var healthDelta = 0;
			if (ruleSpec.heal) {
				healthDelta += +ruleSpec.heal;
			}
			if (ruleSpec.hurt) {
				healthDelta -= +ruleSpec.hurt;
			}

			var teleport;

			if (ruleSpec.teleport) {
				teleport = {
					x: +ruleSpec.teleport.x,
					y: +ruleSpec.teleport.y,
					levelName: ruleSpec.teleport.levelName
				};
			}

			var message;
			if (ruleSpec.message) {
				message = ruleSpec.message;
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

	Generator.generate.levels = function (levelsSpec, legendSpec, tileDimensions) {
		var levelsByName = {};

		var namedStringedLevels = Util.objectToArray(levelsSpec, 'levelName', 'lines');

		namedStringedLevels.forEach(function (namedStringedLevel) {
			var data = namedStringedLevel.lines.map(function (line) {
				return line.split('').map(function (char) {
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
