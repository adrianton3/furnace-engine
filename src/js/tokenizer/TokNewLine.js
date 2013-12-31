define([], function () {
	'use strict';

	function TokNewLine(coords) {
		this.coords = coords;
	}

	TokNewLine.prototype.match = function (that) {
		return that instanceof TokNewLine;
	};

	TokNewLine.prototype.toString = function () {
		return 'TokNewLine';
	};

	TokNewLine.prototype.toHTML = function (c) {
		return '<span style="color:' + c.par + '">)</span>';
	};

	return TokNewLine;
});
