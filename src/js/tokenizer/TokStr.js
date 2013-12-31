define([], function () {
	'use strict';

	function TokStr(s, coords) {
		this.s = s;
		this.coords = coords;
	}

	TokStr.prototype.match = function(that) {
		return that instanceof TokStr;
	};

	TokStr.prototype.toString = function() {
		return "Str(" + this.s + ")";
	};

	TokStr.prototype.toHTML = function(c) {
		return '<span style="color:' + c.str + '">\'' + this.s + '\'</span>';
	};

	return TokStr;
});
