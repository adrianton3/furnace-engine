define([], function() {
	'use strict';

	function TokenList(token) {
		this.token = token;
		this.pointer = 0;
	}

	TokenList.prototype.match = function(token) {
		return this.token[this.pointer].match(token);
	};

	TokenList.prototype.matchSeq = function(token) {
		for(var i = 0; i < token.length; i++)
			if(!(this.token[this.pointer + i].match(token[i])))
				return false;

		return true;
	};

	TokenList.prototype.matchAnySeq = function(token) {
		for(var i = 0; i < token.length; i++)
			if(this.matchSeq(token[i]))
				return true;

		return false;
	};

	TokenList.prototype.expect = function(token, exMessage) {
		if(this.match(token)) this.adv();
		else throw exMessage + this.cur().coords + ' instead got ' + this.cur();
	};

	TokenList.prototype.adv = function() {
		if(this.pointer >= this.token.length)
			throw 'TokenList: You\'ve not enough tokens!';

		this.pointer++;
	};

	TokenList.prototype.next = function() {
		this.adv();
		return this.token[this.pointer - 1];
	};

	TokenList.prototype.cur = function() {
		return this.token[this.pointer];
	};

	TokenList.prototype.past = function() {
		return this.token[this.pointer - 1];
	};

	TokenList.prototype.toString = function() {
		var ret = 'TokenList(pointer: ' + this.pointer
						+ ', content: [' + this.token.join(', ') + ']';
		return ret;
	};

	return TokenList;
});
