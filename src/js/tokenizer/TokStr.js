define(['tokenizer/Token'], function (Token) {
	'use strict';

	function TokStr(value, coords) {
		this.value = value;
		this.coords = coords;
	}

	TokStr.prototype.match = function (that) {
		return that instanceof TokStr;
	};

	TokStr.prototype.toString = function () {
		return 'Str(' + this.value + ')';
	};

	TokStr.prototype.toHTML = function (c) {
		return '<span style="color:' + c.str + '">\'' + this.value + '\'</span>';
	};

	return TokStr;
});
