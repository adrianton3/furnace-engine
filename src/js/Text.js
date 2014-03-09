define([
    'Font',
    'generator/SpriteSheetGenerator',
    'Util'
], function (
    Font,
    SpriteSheetGenerator,
    Util
    ) {

	'use strict';

	var Text = {};

	Text.sprites = [];

	Text.init = function() {
        var namedSprites = SpriteSheetGenerator.generate(Font.spritesByName, Font.colorBindings, 1);

        namedSprites.forEach(function (namedSprite) {
            Text.sprites[namedSprite.name.charCodeAt(0)] = namedSprite.sprite;
        });
	};

	Text.drawAt = function(string, x, y) {
		string += '';

		var chars = string.split('').map(function(char) { return char.charCodeAt(0); });

		for (var i = 0; i < chars.length; i++) {
			var sprite = Text.sprites[chars[i]];
			if (sprite) {
                sprite.drawAt(x + i * 16, y);
            }
		}
	};

	return Text;
});
