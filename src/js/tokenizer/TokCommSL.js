define([], function () {
	'use strict';

	function TokCommSL(s, coords) {
		this.s = s;
		this.coords = coords;
	}

	TokCommSL.prototype.toString = function() {
		return "CommSL(" + this.s + ")";
	};

	TokCommSL.prototype.toHTML = function(c) {
		return '<span style="color:' + c.commSL + '">' + this.s + '</span><br />';
	};

	return TokCommSL;
});
