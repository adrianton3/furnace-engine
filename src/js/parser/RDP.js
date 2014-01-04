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

		var colors = RDP.tree.colors(tokens);
		var player = RDP.tree.player(tokens);
		var objects = RDP.tree.objects(tokens);
		var sets = RDP.tree.sets(tokens);
		var rules = RDP.tree.rules(tokens);
		var legend = RDP.tree.legend(tokens);
		var levels = RDP.tree.levels(tokens);

		//tokens.expect(new TokEnd(), 'RDP: expression not properly terminated');

		return {
			colors: colors,
			player: player,
			objects: objects,
			sets: sets,
			rules: rules,
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

	RDP.tree.colors = function(tokens) {
		tokens.expect('COLORS', 'RDP: must start with colors');
		RDP.tree.chompNL(tokens, 'expected nl after player');

		var colors = {};

		while (!tokens.match('PLAYER')) {
			tokens.expect(RDP.tree.identifier, '');
			var colorChar = tokens.past().s;
			if (colors[colorChar]) {
				throw 'RDP: ' + colorChar + ' already declared';
			}

			tokens.expect('rgb', 'RDP: expected rgb');

			tokens.expect(RDP.tree.identifier, 'RDP: expected red value');
			var r = tokens.past().s;

			tokens.expect(RDP.tree.identifier, 'RDP: expected blue value');
			var g = tokens.past().s;

			tokens.expect(RDP.tree.identifier, 'RDP: expected green value');
			var b = tokens.past().s;

			colors[colorChar] = 'rgb(' + r + ', ' + g + ', ' + b + ')';

			RDP.tree.chompNL(tokens, 'expect at least one new line');
		}

		return colors;
	};

	RDP.tree.player = function(tokens) {
		tokens.expect('PLAYER', 'RDP: PLAYER follows COLORS');
		RDP.tree.chompNL(tokens, 'expected nl after player');

		// --- up ---
		tokens.expect('up', 'must start with up');
		tokens.expect(RDP.tree.newLine, 'expected new line');

		var upLines = [];

		while (!tokens.match('left')) {
			tokens.expect(RDP.tree.identifier, 'expected at least one line');
			upLines.push(tokens.past());

			RDP.tree.chompNL(tokens, 'expect at least one new line');
		}

		// --- left ---
		tokens.expect('left', 'left follows up');
		RDP.tree.chompNL(tokens, 'expect at least one new line');

		var leftLines = [];

		while (!tokens.match('down')) {
			tokens.expect(RDP.tree.identifier, '');
			leftLines.push(tokens.past());

			RDP.tree.chompNL(tokens, 'expect at least one new line');
		}

		// --- down ---
		tokens.expect('down', 'down follows left');
		RDP.tree.chompNL(tokens, 'expect at least one new line');

		var downLines = [];

		while (!tokens.match('right')) {
			tokens.expect(RDP.tree.identifier, 'expected at least one line');
			downLines.push(tokens.past());

			RDP.tree.chompNL(tokens, 'expect at least one new line');
		}

		// --- right ---
		tokens.expect('right', 'right follows down');
		RDP.tree.chompNL(tokens, 'expect at least one new line');

		var rightLines = [];

		while (!tokens.match('OBJECTS')) {
			tokens.expect(RDP.tree.identifier, 'expected at least one line');
			rightLines.push(tokens.past());

			RDP.tree.chompNL(tokens, 'expect at least one new line');
		}

		return { up: upLines, left: leftLines, down: downLines, right: rightLines };
	};

	RDP.tree.objects = function(tokens) {
		tokens.expect('OBJECTS', 'RDP: objects follows player');
		RDP.tree.chompNL(tokens, 'expected nl after objects');


		var objects = {};

		while (!tokens.match('SETS')) {
			// name
			tokens.expect(RDP.tree.identifier, 'expected at least one object');
			var objName = tokens.past().s;
			if (objects[objName]) {
				throw 'RDP: ' + objName + ' already declared';
			}
			objects[objName] = { lines: [] };

			if (tokens.match('blocking')) {
				objects[objName].blocking = true;
				tokens.adv();
			}

			RDP.tree.chompNL(tokens, 'expected nl after objects');

			while (!tokens.match(RDP.tree.newLine)) {
				tokens.expect(RDP.tree.identifier, '');
				objects[objName].lines.push(tokens.past());

				if (tokens.match('blocking')) {
					objects[objName].blocking = true;
				}

				tokens.expect(RDP.tree.newLine, '');
			}

			RDP.tree.chompNL(tokens, 'expected nl after objects');
		}

		return objects;
	};

	RDP.tree.sets = function(tokens) {
		tokens.expect('SETS', 'RDP: sets follows objects');
		RDP.tree.chompNL(tokens, 'expected nl after sets');


		var sets = [];

		while (!tokens.match('RULES')) {
			tokens.expect(RDP.tree.identifier, '');
			var setName = tokens.past().s;

			var set = { name: setName };

			tokens.expect(RDP.tree.assignment, 'expecting assignment operator');
			tokens.expect(RDP.tree.identifier, 'expecting identifier after assignment');
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

			RDP.tree.chompNL(tokens, 'expected nl after sets');
		}

		return sets;
	};

	RDP.tree.rules = function(tokens) {
		tokens.expect('RULES', 'RDP: rules follows sets');
		RDP.tree.chompNL(tokens, 'expected nl after RULES');


		var rules = [];

		while (!tokens.match('LEGEND')) {
			var rule = {};

			tokens.expect(RDP.tree.identifier, 'Expect terrain unit');
			rule.inTerrainItemName = tokens.past();

			tokens.expect(RDP.tree.identifier, 'Expect inventory unit');
			rule.inInventoryItemName = tokens.past();

			tokens.expect(RDP.tree.arrow, 'Expect ->');

			tokens.expect(RDP.tree.identifier, 'Expect out terrain unit');
			rule.outTerrainItemName = tokens.past();

			while (tokens.match(RDP.tree.semicolon)) {
				tokens.adv();

				if (tokens.match('give')) {
					tokens.adv();

					var item = {};

					tokens.expect(RDP.tree.identifier, 'Expect give quantity');
					item.quantity = tokens.past();

					tokens.expect(RDP.tree.identifier, 'Expect give item name');
					item.itemName = tokens.past();

					rule.give = [item];

					while (tokens.match(RDP.tree.comma)) {
						tokens.adv();

						item = {};

						tokens.expect(RDP.tree.identifier, 'Expect give quantity');
						item.quantity = tokens.past();

						tokens.expect(RDP.tree.identifier, 'Expect give item name');
						item.itemName = tokens.past();

						rule.give.push(item);
					}
				} else if (tokens.match('consume')) {
					tokens.adv();

					rule.consume = true;
				} else if (tokens.match('heal')) {
					tokens.adv();

					tokens.expect(RDP.tree.identifier, 'Expect heal quantity');
					rule.heal = tokens.past();
				} else if (tokens.match('hurt')) {
					tokens.adv();

					tokens.expect(RDP.tree.identifier, 'Expect hurt quantity');
					rule.hurt = tokens.past();
				} else if (tokens.match('teleport')) {
					tokens.adv();

					rule.teleport = {};

					tokens.expect(RDP.tree.identifier, 'Expect teleport level name');
					rule.teleport.levelName = tokens.past();

					tokens.expect(RDP.tree.identifier, 'Expect teleport position x');
					rule.teleport.x = tokens.past();

					tokens.expect(RDP.tree.identifier, 'Expect teleport position y');
					rule.teleport.y = tokens.past();
				} else if (tokens.match('message')) {
					tokens.adv();

					tokens.expect(RDP.tree.str, 'Expect message');
					rule.message = tokens.past();
				} //else if (tokens.match(RDP.tree.newLine)) {
				//	break;
				//}
			}

			RDP.tree.chompNL(tokens, 'expected nl between rules');

			rules.push(rule);
		}

		return rules;
	};

	RDP.tree.legend = function(tokens) {
		tokens.expect('LEGEND', 'RDP: legend follows rules');
		RDP.tree.chompNL(tokens, 'expected nl after LEGEND');

		var legend = {};

		while (!tokens.match('LEVELS')) {
			tokens.expect(RDP.tree.identifier, '');
			var terrainChar = tokens.past().s;
			if (legend[terrainChar]) {
				throw 'RDP: ' + terrainChar + ' already declared';
			}

			tokens.expect(RDP.tree.identifier, 'RDP: expected terrain binding');
			legend[terrainChar] = tokens.past().s;

			RDP.tree.chompNL(tokens, 'expect at least one new line');
		}

		return legend;
	};

	RDP.tree.levels = function(tokens) {
		tokens.expect('LEVELS', 'RDP: levels follow legend');
		RDP.tree.chompNL(tokens, 'expected nl after LEVELS');


		var levels = {};

		while (!tokens.match(RDP.tree.end)) {
			tokens.expect(RDP.tree.identifier, 'expected at least one object');
			var levelName = tokens.past().s;
			if (levels[levelName]) {
				throw 'RDP: ' + levelName + ' already declared';
			}

			var lines = [];

			RDP.tree.chompNL(tokens, 'expected nl after objects');

			while (!tokens.match(RDP.tree.newLine)) {
				tokens.expect(RDP.tree.identifier, '');
				lines.push(tokens.past());

				tokens.expect(RDP.tree.newLine, '');
			}

			levels[levelName] = lines;

			RDP.tree.chompNL(tokens, 'expected nl after objects');
		}

		return levels;
	};

	return RDP;
});