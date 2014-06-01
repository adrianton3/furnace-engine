define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokKeyword(value, coords) {
		this.value = value;
		this.coords = coords;
	}

	TokKeyword.prototype.match = function (that) {
		return that === this.value;
	};

	TokKeyword.prototype.toString = function () {
		return 'Keyword(' + this.value + ' ' + this.coords + ')';
	};

	TokKeyword.prototype.toHTML = function (c) {
		return '<span style="font-weight: 900;color:' + c.keyword + '">' + this.value + '</span>';
	};

	return TokKeyword;
});
