define([], function () {
	'use strict';

	function TokIdentifier(s, coords) {
		this.s = s;
		this.coords = coords;
	}

	TokIdentifier.prototype.match = function (that) {
		return that instanceof TokIdentifier;
	};

	TokIdentifier.prototype.toString = function () {
		return "Identifier(" + this.s + ' ' + this.coords + ")";
	};

	TokIdentifier.prototype.toHTML = function (c) {
		return '<span style="color:' + c.identifier + '">' + this.s + '</span>';
	};

	return TokIdentifier;
});
