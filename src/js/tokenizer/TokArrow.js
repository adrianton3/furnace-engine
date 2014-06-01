define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokArrow(coords) {
		this.coords = coords;
	}

	TokArrow.prototype = Object.create(Token.prototype);
	TokArrow.prototype.constructor = TokArrow;

	TokArrow.prototype.match = function (that) {
		return that instanceof TokArrow;
	};

	TokArrow.prototype.toString = function () {
		return 'Arrow';
	};

	TokArrow.prototype.toHTML = function (c) {
		return '<span style="color:' + c.arrow + '">)</span>';
	};

	return TokArrow;
});
