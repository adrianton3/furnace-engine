define([], function () {
	'use strict';

	function TokCommML(s, coords) {
		this.s = s;
		this.coords = coords;
	}

	TokCommML.prototype.toString = function() {
		return 'CommML(' + this.s + ')';
	};

	TokCommML.prototype.toHTML = function(c) {
		return '<span style="color:' + c.commML + '">' + this.s + '</span>';
	};

	return TokCommML;
});
