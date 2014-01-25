define([
	'generator/SpriteSheetGenerator',
	'Util',
	'World',
	'Item',
	'Items',
	'Set',
	'Rule',
	'RuleSet',
	'Vec2',
	'Level'
	], function (
		SpriteSheetGenerator,
		Util,
		World,
		Item,
		Items,
		Set,
		Rule,
		RuleSet,
		Vec2,
		Level
	) {
	'use strict';

	var Generator = {};

	Generator.generate = function(spec) {
		var scale = 8;

		var playerSpritesByName = Generator.generate.player(spec.player, spec.colors, scale);

		var itemsByName = Generator.generate.objects(spec.objects, spec.colors, scale);
		Items.collection = itemsByName;

		var setsByName = Generator.generate.sets(spec.sets);
		var ruleSet = Generator.generate.rules(spec.rules, setsByName);

		// sort of hacky
		var tileDimensions = playerSpritesByName.left.end.sub(playerSpritesByName.left.start);

		var levelsByName = Generator.generate.levels(spec.levels, spec.legend, tileDimensions);

		var startLocation = { x: 4, y: 4, levelName: 'entry' };
		var world = new World(playerSpritesByName, levelsByName, startLocation, ruleSet, tileDimensions);

		return world;
	};

	Generator.generate.player = function(playerSpec, colorSpec, scale) {
		var namedPlayerSprites = SpriteSheetGenerator.generate(playerSpec, colorSpec, scale);
		var playerSpritesByName = Util.arrayToObject(namedPlayerSprites, 'name', 'sprite');
		return playerSpritesByName;
	};

	Generator.generate.objects = function(objectsSpec, colorSpec, scale) {
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

	Generator.generate.rules = function(rulesSpec, setsByName) {
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
					level: ruleSpec.teleport.levelName.s
				};
			}

			var message;
			if (ruleSpec.message) {
				message = ruleSpec.message.s;
			}

			return new Rule(
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

			levelsByName[namedStringedLevel.levelName] = new Level(data, levelDimensions, tileDimensions);
		});

		return levelsByName;
	};

	return Generator;
});
