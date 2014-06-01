define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokIdentifier(value, coords) {
		this.value = value;
		this.coords = coords;
	}

	TokIdentifier.prototype = Object.create(Token.prototype);
	TokIdentifier.prototype.constructor = TokIdentifier;

	TokIdentifier.prototype.match = function (that) {
		return that instanceof TokIdentifier;
	};

	TokIdentifier.prototype.toString = function () {
		return 'Identifier(' + this.value + ' ' + this.coords + ')';
	};

	TokIdentifier.prototype.toHTML = function (c) {
		return '<span style="color:' + c.identifier + '">' + this.s + '</span>';
	};

	return TokIdentifier;
});
