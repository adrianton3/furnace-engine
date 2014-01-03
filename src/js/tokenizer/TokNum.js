define([], function () {
	'use strict';

	function TokNum(s, coords) {
		this.n = parseFloat(s);
		this.coords = coords;
	}

	TokNum.prototype.match = function(that) {
		return that instanceof TokNum;
	};

	TokNum.prototype.toString = function() {
		return "Num(" + this.n + ")";
	};

	TokNum.prototype.toHTML = function(c) {
		return '<span style="color:' + c.num + '">' + this.n + '</span>';
	};

	return TokNum;
});
