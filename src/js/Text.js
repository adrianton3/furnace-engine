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
        var spritesByName = Util.arrayToObject(namedSprites, 'name', 'sprite');

        for (var i = 0; i < 10; i++) {
            Text.sprites[i + 48] = spritesByName[i];
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
