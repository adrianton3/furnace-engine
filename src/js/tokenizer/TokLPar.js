define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokLPar(coords) {
		this.coords = coords;
	}

	TokLPar.prototype.match = function (that) {
		return that instanceof TokLPar;
	};

	TokLPar.prototype.toString = function () {
		return 'LPar';
	};

	TokLPar.prototype.toHTML = function (c) {
		return '<span style="color:' + c.par + '">(</span>';
	};

	return TokLPar;
});
