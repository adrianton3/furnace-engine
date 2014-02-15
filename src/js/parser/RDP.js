define([
	'tokenizer/IterableString',
	'tokenizer/TokEnd',
	'tokenizer/TokNum',
	'tokenizer/TokIdentifier',
	'tokenizer/TokStr',
	'tokenizer/TokLPar',
	'tokenizer/TokRPar',
	'tokenizer/TokKeyword',
	'tokenizer/TokWhitespace',
	'tokenizer/TokCommSL',
	'tokenizer/TokCommML',
	'tokenizer/TokComma',
	'tokenizer/TokSemicolon',
	'tokenizer/TokArrow',
	'tokenizer/TokNewLine',
	'tokenizer/TokAssignment',
	'tokenizer/TokenCoords',
	'parser/TokenList'
	], function (
		IterableString,
		TokEnd,
		TokNum,
		TokIdentifier,
		TokStr,
		TokLPar,
		TokRPar,
		TokKeyword,
		TokWhitespace,
		TokCommSL,
		TokCommML,
		TokComma,
		TokSemicolon,
		TokArrow,
		TokNewLine,
		TokAssignment,
		TokenCoords,
		TokenList
	) {
		'use strict';

	var RDP = {};

	RDP.errPref = 'Parsing exception: ';

	RDP.parse = function(tokenArray) {
		var tokens = new TokenList(tokenArray);

		var params = RDP.tree.params(tokens);
		var colors = RDP.tree.colors(tokens);
		var player = RDP.tree.player(tokens);
		var objects = RDP.tree.objects(tokens);
		var sets = RDP.tree.sets(tokens);
        var nearRules = RDP.tree.nearRules(tokens);
		var leaveRules = RDP.tree.leaveRules(tokens);
		var enterRules = RDP.tree.enterRules(tokens);
		var useRules = RDP.tree.useRules(tokens);
		var legend = RDP.tree.legend(tokens);
		var levels = RDP.tree.levels(tokens);

		//tokens.expect(new TokEnd(), 'RDP: expression not properly terminated');

		return {
			params: params,
			colors: colors,
			player: player,
			objects: objects,
			sets: sets,
            nearRules: nearRules,
			leaveRules: leaveRules,
			enterRules: enterRules,
			useRules: useRules,
			legend: legend,
			levels: levels
		};
	};

	RDP.tree = {};

	RDP.tree.num = new TokNum();
	RDP.tree.identifier = new TokIdentifier();
	RDP.tree.str = new TokStr();

	RDP.tree.lPar = new TokLPar();
	RDP.tree.rPar = new TokRPar();

	RDP.tree.comma = new TokComma();
	RDP.tree.semicolon = new TokSemicolon();
	RDP.tree.arrow = new TokArrow();
	RDP.tree.newLine = new TokNewLine();
	RDP.tree.assignment = new TokAssignment();

	RDP.tree.end = new TokEnd();

	RDP.tree.chompNL = function(tokens, exMessage) {
		tokens.expect(RDP.tree.newLine, exMessage);
		while (tokens.match(RDP.tree.newLine)) {
			tokens.adv();
		}
	};

	RDP.tree.params = function(tokens) {
		tokens.expect('PARAM', 'Specification must start with PARAM');
		RDP.tree.chompNL(tokens, 'Expected new line after PARAM');

		var params = {};

		while (!tokens.match('COLORS')) {
			tokens.expect(RDP.tree.identifier, '');
			var paramName = tokens.past().s;
			if (params[paramName]) {
				throw 'Param definition ' + paramName + ' already declared';
			}

			params[paramName] = [];

			while (tokens.match(RDP.tree.identifier)) {
				tokens.adv();
				params[paramName].push(tokens.past());
			}

			RDP.tree.chompNL(tokens, 'Expect new line between param declarations');
		}

		return params;
	};

	RDP.tree.colors = function(tokens) {
		tokens.expect('COLORS', 'Expected COLORS section after PARAM');
		RDP.tree.chompNL(tokens, 'Expected new line after COLORS');

		var colors = {};

		while (!tokens.match('PLAYER')) {
			tokens.expect(RDP.tree.identifier, '');
			var colorChar = tokens.past().s;
			if (colors[colorChar]) {
				throw 'Color binding ' + colorChar + ' already declared';
			}

			tokens.expect('rgb', 'Expected rgb');

			tokens.expect(RDP.tree.identifier, 'Expected red value');
			var r = tokens.past().s;

			tokens.expect(RDP.tree.identifier, 'Expected blue value');
			var g = tokens.past().s;

			tokens.expect(RDP.tree.identifier, 'Expected green value');
			var b = tokens.past().s;

			colors[colorChar] = 'rgb(' + r + ', ' + g + ', ' + b + ')';

			RDP.tree.chompNL(tokens, 'Expect new line between color bindings');
		}

		return colors;
	};

	RDP.tree.player = function(tokens) {
		tokens.expect('PLAYER', 'Expected PLAYER section after COLORS');
		RDP.tree.chompNL(tokens, 'Expected new line after PLAYER');


		var playerFrames = {};

		while (!tokens.match('OBJECTS')) {
			// name
			tokens.expect(RDP.tree.identifier, 'Expected at least one player frame');
			var playerFrameName = tokens.past().s;
			if (playerFrames[playerFrameName]) {
				throw playerFrameName + ' already declared';
			}
			playerFrames[playerFrameName] = [];

			RDP.tree.chompNL(tokens, 'Expected new line after player frame binding');

			while (!tokens.match(RDP.tree.newLine)) {
				tokens.expect(RDP.tree.identifier, '');
				playerFrames[playerFrameName].push(tokens.past());

				tokens.expect(RDP.tree.newLine, '');
			}

			RDP.tree.chompNL(tokens, 'Expected new line after player frame declaration');
		}

		return playerFrames;
	};

	RDP.tree.objects = function(tokens) {
		tokens.expect('OBJECTS', 'Expected OBJECTS section after PLAYER');
		RDP.tree.chompNL(tokens, 'Expected new line after OBJECTS');


		var objects = {};

		while (!tokens.match('SETS')) {
			// name
			tokens.expect(RDP.tree.identifier, 'Expected at least one object');
			var objName = tokens.past().s;
			if (objects[objName]) {
				throw objName + ' already declared';
			}
			objects[objName] = { lines: [] };

			if (tokens.match('blocking')) {
				objects[objName].blocking = true;
				tokens.adv();
			}

			RDP.tree.chompNL(tokens, 'Expected new line after object name binding');

			while (!tokens.match(RDP.tree.newLine)) {
				tokens.expect(RDP.tree.identifier, '');
				objects[objName].lines.push(tokens.past());

				if (tokens.match('blocking')) {
					objects[objName].blocking = true;
				}

				tokens.expect(RDP.tree.newLine, '');
			}

			RDP.tree.chompNL(tokens, 'Expected new line after object declaration');
		}

		return objects;
	};

	RDP.tree.sets = function(tokens) {
		tokens.expect('SETS', 'Expected SETS after OBJECTS');
		RDP.tree.chompNL(tokens, 'Expected new line after SETS');


		var sets = [];

		while (!tokens.match('NEARRULES')) {
			tokens.expect(RDP.tree.identifier, '');
			var setName = tokens.past().s;

			var set = { name: setName };

			tokens.expect(RDP.tree.assignment, 'Expecting assignment operator');
			tokens.expect(RDP.tree.identifier, 'Expecting identifier after assignment');
			var firstOperandOrElement = tokens.past().s;

			if (tokens.match('or') || tokens.match('and') || tokens.match('minus')) {
				var operator = tokens.next().s;
				tokens.expect(RDP.tree.identifier);
				var secondOperand = tokens.past().s;

				set.operator = operator;
				set.operand1 = firstOperandOrElement;
				set.operand2 = secondOperand;
			} else {
				var elements = [firstOperandOrElement];
				while (tokens.match(RDP.tree.identifier)) {
					elements.push(tokens.next().s);
				}

				set.elements = elements;
			}

			sets.push(set);

			RDP.tree.chompNL(tokens, 'Expected new line after set declaration');
		}

		return sets;
	};

    RDP.tree.nearRules = function(tokens) {
        tokens.expect('NEARRULES', 'Expected NEARRULES section after SETS');
        RDP.tree.chompNL(tokens, 'Expected new line after NEARRULES');


        var rules = [];

        while (!tokens.match('LEAVERULES')) {
            var rule = {};

            tokens.expect(RDP.tree.identifier, 'Expected terrain unit');
            rule.inTerrainItemName = tokens.past();

            tokens.expect(RDP.tree.arrow, 'Expected ->');

            tokens.expect(RDP.tree.identifier, 'Expected out terrain unit');
            rule.outTerrainItemName = tokens.past();

            while (tokens.match(RDP.tree.semicolon)) {
                tokens.adv();

                if (tokens.match('heal')) {
                    tokens.adv();

                    tokens.expect(RDP.tree.identifier, 'Expected heal quantity');
                    rule.heal = tokens.past();
                } else if (tokens.match('hurt')) {
                    tokens.adv();

                    tokens.expect(RDP.tree.identifier, 'Expected hurt quantity');
                    rule.hurt = tokens.past();
                }
            }

            RDP.tree.chompNL(tokens, 'Expected new line between rules');

            rules.push(rule);
        }

        return rules;
    };

	RDP.tree.leaveRules = function(tokens) {
		tokens.expect('LEAVERULES', 'Expected LEAVERULES section after SETS');
		RDP.tree.chompNL(tokens, 'Expected new line after LEAVERULES');


		var rules = [];

		while (!tokens.match('ENTERRULES')) {
			var rule = {};

			tokens.expect(RDP.tree.identifier, 'Expected terrain unit');
			rule.inTerrainItemName = tokens.past();

			tokens.expect(RDP.tree.arrow, 'Expected ->');

			tokens.expect(RDP.tree.identifier, 'Expected out terrain unit');
			rule.outTerrainItemName = tokens.past();

			RDP.tree.chompNL(tokens, 'Expected new line between rules');

			rules.push(rule);
		}

		return rules;
	};

	RDP.tree.enterRules = function(tokens) {
		tokens.expect('ENTERRULES', 'Expected ENTERRULES section after LEAVERULES');
		RDP.tree.chompNL(tokens, 'Expected new line after ENTERRULES');


		var rules = [];

		while (!tokens.match('USERULES')) {
			var rule = {};

			tokens.expect(RDP.tree.identifier, 'Expected terrain unit');
			rule.inTerrainItemName = tokens.past();

			tokens.expect(RDP.tree.arrow, 'Expected ->');

			tokens.expect(RDP.tree.identifier, 'Expected out terrain unit');
			rule.outTerrainItemName = tokens.past();

			while (tokens.match(RDP.tree.semicolon)) {
				tokens.adv();

				if (tokens.match('give')) {
					tokens.adv();

					var item = {};

					tokens.expect(RDP.tree.identifier, 'Expected give quantity');
					item.quantity = tokens.past();

					tokens.expect(RDP.tree.identifier, 'Expected give item name');
					item.itemName = tokens.past();

					rule.give = [item];

					while (tokens.match(RDP.tree.comma)) {
						tokens.adv();

						item = {};

						tokens.expect(RDP.tree.identifier, 'Expected give quantity');
						item.quantity = tokens.past();

						tokens.expect(RDP.tree.identifier, 'Expected give item name');
						item.itemName = tokens.past();

						rule.give.push(item);
					}
				} else if (tokens.match('heal')) {
					tokens.adv();

					tokens.expect(RDP.tree.identifier, 'Expected heal quantity');
					rule.heal = tokens.past();
				} else if (tokens.match('hurt')) {
					tokens.adv();

					tokens.expect(RDP.tree.identifier, 'Expected hurt quantity');
					rule.hurt = tokens.past();
				} else if (tokens.match('teleport')) {
					tokens.adv();

					rule.teleport = {};

					tokens.expect(RDP.tree.identifier, 'Expected teleport level name');
					rule.teleport.levelName = tokens.past();

					tokens.expect(RDP.tree.identifier, 'Expected teleport position X');
					rule.teleport.x = tokens.past();

					tokens.expect(RDP.tree.identifier, 'Expected teleport position Y');
					rule.teleport.y = tokens.past();
				} else if (tokens.match('message')) {
					tokens.adv();

					tokens.expect(RDP.tree.str, 'Expected message');
					rule.message = tokens.past();
				}
			}

			RDP.tree.chompNL(tokens, 'Expected new line between rules');

			rules.push(rule);
		}

		return rules;
	};

	RDP.tree.useRules = function(tokens) {
		tokens.expect('USERULES', 'Expected USERULES section after SETS');
		RDP.tree.chompNL(tokens, 'Expected new line after USERULES');


		var rules = [];

		while (!tokens.match('LEGEND')) {
			var rule = {};

			tokens.expect(RDP.tree.identifier, 'Expected terrain unit');
			rule.inTerrainItemName = tokens.past();

			tokens.expect(RDP.tree.identifier, 'Expected inventory unit');
			rule.inInventoryItemName = tokens.past();

			tokens.expect(RDP.tree.arrow, 'Expected ->');

			tokens.expect(RDP.tree.identifier, 'Expected out terrain unit');
			rule.outTerrainItemName = tokens.past();

			while (tokens.match(RDP.tree.semicolon)) {
				tokens.adv();

				if (tokens.match('give')) {
					tokens.adv();

					var item = {};

					tokens.expect(RDP.tree.identifier, 'Expected give quantity');
					item.quantity = tokens.past();

					tokens.expect(RDP.tree.identifier, 'Expected give item name');
					item.itemName = tokens.past();

					rule.give = [item];

					while (tokens.match(RDP.tree.comma)) {
						tokens.adv();

						item = {};

						tokens.expect(RDP.tree.identifier, 'Expected give quantity');
						item.quantity = tokens.past();

						tokens.expect(RDP.tree.identifier, 'Expected give item name');
						item.itemName = tokens.past();

						rule.give.push(item);
					}
				} else if (tokens.match('consume')) {
					tokens.adv();

					rule.consume = true;
				} else if (tokens.match('heal')) {
					tokens.adv();

					tokens.expect(RDP.tree.identifier, 'Expected heal quantity');
					rule.heal = tokens.past();
				} else if (tokens.match('hurt')) {
					tokens.adv();

					tokens.expect(RDP.tree.identifier, 'Expected hurt quantity');
					rule.hurt = tokens.past();
				} else if (tokens.match('teleport')) {
					tokens.adv();

					rule.teleport = {};

					tokens.expect(RDP.tree.identifier, 'Expected teleport level name');
					rule.teleport.levelName = tokens.past();

					tokens.expect(RDP.tree.identifier, 'Expected teleport position X');
					rule.teleport.x = tokens.past();

					tokens.expect(RDP.tree.identifier, 'Expected teleport position Y');
					rule.teleport.y = tokens.past();
				} else if (tokens.match('message')) {
					tokens.adv();

					tokens.expect(RDP.tree.str, 'Expected message');
					rule.message = tokens.past();
				}
			}

			RDP.tree.chompNL(tokens, 'Expected new line between rules');

			rules.push(rule);
		}

		return rules;
	};

	RDP.tree.legend = function(tokens) {
		tokens.expect('LEGEND', 'Expected LEGEND section after RULES');
		RDP.tree.chompNL(tokens, 'Expected new line after LEGEND');

		var legend = {};

		while (!tokens.match('LEVELS')) {
			tokens.expect(RDP.tree.identifier, '');
			var terrainChar = tokens.past().s;
			if (legend[terrainChar]) {
				throw terrainChar + ' already declared';
			}

			tokens.expect(RDP.tree.identifier, 'Expected terrain binding');
			legend[terrainChar] = tokens.past().s;

			RDP.tree.chompNL(tokens, 'Expected new line');
		}

		return legend;
	};

	RDP.tree.levels = function(tokens) {
		tokens.expect('LEVELS', 'Expected LEVELS section after LEGEND');
		RDP.tree.chompNL(tokens, 'Expected new line after LEVELS');


		var levels = {};

		while (!tokens.match(RDP.tree.end)) {
			tokens.expect(RDP.tree.identifier, 'Expected at least one level');
			var levelName = tokens.past().s;
			if (levels[levelName]) {
				throw levelName + ' already declared';
			}

			var lines = [];

			RDP.tree.chompNL(tokens, 'Expected new line after level name binding');

			while (!tokens.match(RDP.tree.newLine)) {
				tokens.expect(RDP.tree.identifier, '');
				lines.push(tokens.past());

				tokens.expect(RDP.tree.newLine, '');
			}

			levels[levelName] = lines;

			RDP.tree.chompNL(tokens, 'Expected new line after level declaration');
		}

		return levels;
	};

	return RDP;
});