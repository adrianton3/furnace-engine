define([
	'Sprite',
	'Vec2'
	], function (
		Sprite,
		Vec2
	) {
	'use strict';

	function SpriteSheet(image, width, height) {
		this.image = image;
		this.width = width;
		this.height = height;
		this.spriteWidth = Math.floor(this.image.width / this.width);
		this.spriteHeight = Math.floor(this.image.height / this.height);
	}

	SpriteSheet.prototype.getSprite = function(x, y) {
		return new Sprite(
			this.image,
			new Vec2(this.spriteWidth * x, this.spriteHeight * y),
			new Vec2((x + 1) * this.spriteWidth, (y + 1) * this.spriteHeight)
		);
	};

	return SpriteSheet;
});
