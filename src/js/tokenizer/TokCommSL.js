define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokCommSL(value, coords) {
		this.value = value;
		this.coords = coords;
	}

	TokCommSL.prototype.toString = function() {
		return 'CommSL(' + this.value + ')';
	};

	TokCommSL.prototype.toHTML = function(c) {
		return '<span style="color:' + c.commSL + '">' + this.value + '</span><br />';
	};

	return TokCommSL;
});
