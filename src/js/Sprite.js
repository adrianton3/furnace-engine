define([
	'con2d'
	], function (
		con2d
	) {
	'use strict';

	function Sprite(spriteSheet, start, end) {
		this.spriteSheet = spriteSheet;
		this.start = start;
		this.end = end;
	}

	Sprite.prototype.drawAt = function(x, y) {
		con2d.drawImage(
			this.spriteSheet,
			this.start.x, this.start.y, this.end.x - this.start.x, this.end.y - this.start.y,
			x, y, this.end.x - this.start.x, this.end.y - this.start.y
		);
	};

	return Sprite;
});
