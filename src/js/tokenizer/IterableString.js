define([
	'tokenizer/TokenCoords'
	], function (
		TokenCoords
	) {
	'use strict';

	function IterableString(str) {
		this.str = str;
		this.pointer = 0;
		this.marker = 0;

		this.line = 1;
		this.col = 1;
	}

	IterableString.prototype.advance = function () {
		if (this.str.charAt(this.pointer) === '\n') {
			this.line++;
			this.col = 1;
		} else {
			this.col++;
		}

		this.pointer++;
	};

	IterableString.prototype.setMarker = function (offset) {
		offset = offset || 0;
		this.marker = this.pointer + offset;
	};

	IterableString.prototype.current = function () {
		return this.str.charAt(this.pointer);
	};

	IterableString.prototype.next = function () {
		return this.str.charAt(this.pointer + 1);
	};

	IterableString.prototype.hasNext = function () {
		return this.pointer < this.str.length;
	};

	IterableString.prototype.getMarked = function (offset) {
		offset = offset || 0;
		return this.str.substring(this.marker, this.pointer + offset);
	};

	IterableString.prototype.getCoords = function () {
		return new TokenCoords(this.line, this.col);
	};

	return IterableString;
});
