define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokCommML(value, coords) {
		this.value = value;
		this.coords = coords;
	}

	TokCommML.prototype.toString = function () {
		return 'CommML(' + this.value + ')';
	};

	TokCommML.prototype.toHTML = function(c) {
		return '<span style="color:' + c.commML + '">' + this.value + '</span>';
	};

	return TokCommML;
});
