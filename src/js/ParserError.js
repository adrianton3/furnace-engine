define([], function() {
	'use strict';

	function ParserError(message, line, column) {
	  this.name = 'ParserError';
	  this.message = message || 'Default Message';
	  this.line = line;
	  this.column = column;
	}

	ParserError.prototype = Object.create(Error.prototype);
	ParserError.prototype.constructor = ParserError;

	return ParserError;
});