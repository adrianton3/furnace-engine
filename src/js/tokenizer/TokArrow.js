define([], function () {
	'use strict';

	function TokArrow(coords) {
		this.coords = coords;
	}

	TokArrow.prototype.match = function(that) {
		return that instanceof TokArrow;
	};

	TokArrow.prototype.toString = function() {
		return 'Arrow';
	};

	TokArrow.prototype.toHTML = function(c) {
		return '<span style="color:' + c.arrow + '">)</span>';
	};

	return TokArrow;
});
