define([
	'tokenizer/TokenCoords'
	], function(
		TokenCoords
	) {
	'use strict';

	function IterableString(s) {
		this.s = s;
		this.pointer = 0;
		this.marker = 0;

		this.line = 0;
		this.col = 0;
	}

	IterableString.prototype.adv = function() {
		if(this.s.charAt(this.pointer) == '\n') {
			this.line++;
			this.col = 0;
		}
		else this.col++;

		this.pointer++;
	};

	IterableString.prototype.setMarker = function() {
		this.marker = this.pointer;
	};

	IterableString.prototype.cur = function() {
		return this.s.charAt(this.pointer);
	};

	IterableString.prototype.next = function() {
		return this.s.charAt(this.pointer + 1);
	};

	IterableString.prototype.hasNext = function() {
		return this.pointer < this.s.length;
	};

	IterableString.prototype.getMarked = function() {
		return this.s.substring(this.marker, this.pointer);
	};

	IterableString.prototype.match = function(str) {
		var substr = this.s.substring(this.pointer, this.pointer + str.length);
		if(substr == str) {
			this.pointer += str.length;

			var count = str.match(/\n/g).length;
			if(count > 0) {
				this.line += count;
				this.col = str.length - str.lastIndexOf('\n');
			}
			else this.col += str.length;

			return true;
		}
		return false;
	};

	IterableString.prototype.getCoords = function() {
		return new TokenCoords(this.line, this.col);
	};

	return IterableString;
});
