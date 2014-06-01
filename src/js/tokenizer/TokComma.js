define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokComma(coords) {
		this.coords = coords;
	}

	TokComma.prototype.match = function (that) {
		return that instanceof TokComma;
	};

	TokComma.prototype.toString = function () {
		return 'Comma';
	};

	TokComma.prototype.toHTML = function (c) {
		return '<span style="color:' + c.comma + '">)</span>';
	};

	return TokComma;
});
