define([], function () {
	'use strict';

	function TokKeyword(s, coords) {
		this.s = s;
		this.coords = coords;
	}

	TokKeyword.prototype.match = function(that) {
		return that === this.s;
	};

	TokKeyword.prototype.toString = function() {
		return "Keyword(" + this.s + ' ' + this.coords + ")";
	};

	TokKeyword.prototype.toHTML = function(c) {
		return '<span style="font-weight: 900;color:' + c.keyword + '">' + this.s + '</span>';
	};

	return TokKeyword;
});
