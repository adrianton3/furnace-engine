define(['SpriteSheetStore'], function (SpriteSheetStore) {
	// should store text files in some other way
	'use strict';

	var Text = {};

	Text.sprites = [];

	Text.init = function() {
		var spriteSheet = SpriteSheetStore.text;
		for (var i = 0; i < 10; i++) {
			Text.sprites[i + 48] = spriteSheet.getSprite(i, 0);
		}
	};

	Text.drawAt = function(string, x, y) {
		string += '';

		var chars = string.split('').map(function(char) { return char.charCodeAt(0); });

		for (var i = 0; i < chars.length; i++) {
			var sprite = Text.sprites[chars[i]];
			sprite.drawAt(x + i * 16, y);
		}
	};

	return Text;
});
