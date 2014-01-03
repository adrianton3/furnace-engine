define([], function () {
	'use strict';

	function TokEnd(coords) {
		this.coords = coords;
	}

	TokEnd.prototype.match = function(that) {
		return that instanceof TokEnd;
	};

	TokEnd.prototype.toString = function() {
		return "END";
	};

	TokEnd.prototype.toHTML = function(c) {
		return '';
	};

	return TokEnd;
});
