define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokRPar(coords) {
		this.coords = coords;
	}

	TokRPar.prototype.match = function (that) {
		return that instanceof TokRPar;
	};

	TokRPar.prototype.toString = function () {
		return 'RPar';
	};

	TokRPar.prototype.toHTML = function (c) {
		return '<span style="color:' + c.par + '">)</span>';
	};

	return TokRPar;
});
