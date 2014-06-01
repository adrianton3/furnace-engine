define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokSemicolon(coords) {
		this.coords = coords;
	}

	TokSemicolon.prototype.match = function (that) {
		return that instanceof TokSemicolon;
	};

	TokSemicolon.prototype.toString = function () {
		return 'Semicolon';
	};

	TokSemicolon.prototype.toHTML = function (c) {
		return '<span style="color:' + c.semicolon + '">)</span>';
	};

	return TokSemicolon;
});
