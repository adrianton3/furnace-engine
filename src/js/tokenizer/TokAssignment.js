define([], function () {
	'use strict';

	function TokAssignment(coords) {
		this.coords = coords;
	}

	TokAssignment.prototype.match = function(that) {
		return that instanceof TokAssignment;
	};

	TokAssignment.prototype.toString = function() {
		return 'Assignment';
	};

	TokAssignment.prototype.toHTML = function(c) {
		return '<span style="color:' + c.assignment + '">)</span>';
	};

	return TokAssignment;
});
