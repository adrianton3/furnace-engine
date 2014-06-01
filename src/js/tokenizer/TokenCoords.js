define([], function () {
	'use strict';

	function TokenCoords(line, col) {
		this.line = line;
		this.col = col;
	}

	TokenCoords.prototype.toString = function () {
		return '(line: ' + this.line + ', col: ' + this.col + ')';
	};

	return TokenCoords;
});
