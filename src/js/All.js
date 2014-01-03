define([], function () {
	'use strict';

	function All(expected, onComplete) {
		this.expected = expected;
		this.completed = 0;
		this.onComplete = onComplete;
	}

	All.prototype.getCallback = function() {
		return function() {
			this.completed++;
			if (this.completed === this.expected) {
				this.onComplete();
			}
		}.bind(this);
	};

	return All;
});
