define([], function() {
	'use strict';

	var PrettyPrinter = {};

	PrettyPrinter.print = function (spec) {
		return [
			PrettyPrinter.print.params(spec.params),
			PrettyPrinter.print.colors(spec.colors),
			PrettyPrinter.print.player(spec.player),
			PrettyPrinter.print.objects(spec.objects),
			PrettyPrinter.print.sets(spec.sets),
            PrettyPrinter.print.nearRules(spec.nearRules),
			PrettyPrinter.print.leaveRules(spec.leaveRules),
			PrettyPrinter.print.enterRules(spec.enterRules),
			PrettyPrinter.print.useRules(spec.useRules),
			PrettyPrinter.print.legend(spec.legend),
			PrettyPrinter.print.levels(spec.levels)
		].join('\n');
	};

	PrettyPrinter.print.params = function (spec) {
		var str = 'PARAM\n\n';
		for (var key in spec) {
			str += key + ' ' + spec[key].map(function (token) { return token.s; }).join(' ') + '\n';
		}
		return str;
	};

	PrettyPrinter.print.colors = function (spec) {
		var str = 'COLORS\n\n';
		for (var key in spec) {
			str += key + ' ' + spec[key] + '\n';
		}
		return str;
	};

	PrettyPrinter.print.player = function (spec) {
		var str = 'PLAYER\n\n';
		for (var key in spec) {
			var sprite = spec[key].map(function (identifier) { return identifier.s; }).join('\n');
			str += key + '\n' + sprite + '\n\n';
		}
		return str;
	};

	PrettyPrinter.print.objects = function (spec) {
		var str = 'OBJECTS\n\n';
		for (var key in spec) {
			var sprite = spec[key].lines.map(function (identifier) { return identifier.s; }).join('\n');
			str += key + (spec[key].blocking ? ' blocking' : '') + '\n' + sprite + '\n\n';
		}
		return str;
	};

	PrettyPrinter.print.sets = function (spec) {
		var str = 'SETS\n\n';
		spec.forEach(function (setDeclaration) {
			str += setDeclaration.name + ' = ';

			if (setDeclaration.elements) {
				str += setDeclaration.elements.join(' ');
			} else {
				str += setDeclaration.operand1 + ' ' + spec[key].operator + ' ' + spec[key].operand2;
			}

			str += '\n';
		});
		return str;
	};

    PrettyPrinter.print.nearRules = function (spec) {
        var str = 'NEARRULES\n\n';

        spec.forEach(function (rule) {
            str += rule.inTerrainItemName.s + ' -> ' + rule.outTerrainItemName.s + ';';

            if (rule.heal) {
                str += ' heal ' + rule.heal.s + ' ;';
            }

            if (rule.hurt) {
                str += ' hurt ' + rule.hurt.s + ' ;';
            }

            str += '\n';
        });

        return str;
    };

	PrettyPrinter.print.leaveRules = function (spec) {
		var str = 'LEAVERULES\n\n';

		spec.forEach(function (rule) {
			str += rule.inTerrainItemName.s + ' -> ' + rule.outTerrainItemName.s + ';\n';
		});

		return str;
	};

	PrettyPrinter.print.enterRules = function (spec) {
		var str = 'ENTERRULES\n\n';

		spec.forEach(function (rule) {
			str += rule.inTerrainItemName.s + ' -> ' + rule.outTerrainItemName.s + ';';

			if (rule.give) {
				var giveStr = rule.give.map(function (item) {
					return item.quantity.s + ' ' + item.itemName.s;
				}).join(' , ');
				str += ' ' + giveStr + ' ;';
            }

			if (rule.heal) {
				str += ' heal ' + rule.heal.s + ' ;';
			}

			if (rule.hurt) {
				str += ' hurt ' + rule.hurt.s + ' ;';
			}

			if (rule.teleport) {
				str += ' teleport ' + rule.teleport.levelName + ' ' + rule.teleport.x + ' ' + rule.teleport.y + ';';
			}

			if (rule.message) {
				str += ' message "' + rule.message + '" ;';
			}

			str += '\n';
		});

		return str;
	};

	PrettyPrinter.print.useRules = function (spec) {
		var str = 'USERULES\n\n';

		spec.forEach(function (rule) {
			str += rule.inTerrainItemName.s + ' ' + rule.inInventoryItemName.s + ' -> ' + rule.outTerrainItemName.s + ';';

			if (rule.give) {
				var giveStr = rule.give.map(function (item) {
					return item.quantity.s + ' ' + item.itemName.s;
				}).join(' , ');
				str += ' ' + giveStr + ' ;';
			}

			if (rule.consume) {
				str += ' consume ;';
			}

			if (rule.heal) {
				str += ' heal ' + rule.heal.s + ' ;';
			}

			if (rule.hurt) {
				str += ' hurt ' + rule.hurt.s + ' ;';
			}

			if (rule.teleport) {
				str += ' teleport ' + rule.teleport.levelName + ' ' + rule.teleport.x + ' ' + rule.teleport.y + ';';
			}

			if (rule.message) {
				str += ' message "' + rule.message + '" ;';
			}

			str += '\n';
		});

		return str;
	};

	PrettyPrinter.print.legend = function (spec) {
		var str = 'LEGEND\n\n';
		for (var key in spec) {
			str += key + ' ' + spec[key] + '\n';
		}
		return str;
	};

	PrettyPrinter.print.levels = function (spec) {
		var str = 'LEVELS\n\n';
		for (var key in spec) {
			var data = spec[key].map(function (identifier) { return identifier.s; }).join('\n');
			str += key + '\n' + data + '\n\n';
		}
		return str;
	};

	return PrettyPrinter;
});
