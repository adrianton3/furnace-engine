define([], function () {
	'use strict';

	function TokWhitespace(s) {
		this.s = s;
	}

	TokWhitespace.prototype.match = function(that) {
		return that instanceof TokWhitespace;
	};

	TokWhitespace.prototype.toString = function() {
		return 'Whitespace(' + this.s + ')';
	};

	TokWhitespace.prototype.toHTML = function(c) {
		if(this.s == '\n') return '<br />';
		else if(this.s == ' ') return '<span style="color:' + c.whitespace + '">&nbsp;</span>';
		else return '<span style="color:' + c.whitespace + '">' + this.s + '</span>';
	};

	return TokWhitespace;
});
