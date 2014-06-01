define([
	'Util',
	'SpriteSheet'
	], function (
		Util, SpriteSheet
	) {
	'use strict';

	var SpriteSheetGenerator = {};

	SpriteSheetGenerator.generate = function(stringedSprites, colorBindings, scale) {
		var colorsByBinding = Util.arrayToObject(colorBindings.map(function (binding) {
			var stringedColor = binding.alpha !== undefined ?
				'rgba(' + binding.red + ',' + binding.green + ',' + binding.blue + ',' + binding.alpha + ')' :
				'rgb(' + binding.red + ',' + binding.green + ',' + binding.blue + ')';

			return { name: binding.name, stringedColor: stringedColor };
		}), 'name', 'stringedColor');

		var width = Math.ceil(Math.sqrt(stringedSprites.length));

		var canvas = document.createElement('canvas');

		canvas.width = stringedSprites[0].data.length * width * scale;
		canvas.height = stringedSprites[0].data.length * width * scale;
		var con2d = canvas.getContext('2d');

		function pixel(x, y, color) {
			con2d.fillStyle = color;
			con2d.fillRect(x * scale, y * scale, scale, scale);
		}

		function paint(x, y, data) {
			var baseOffsetX = x * data.length;
			var baseOffsetY = y * data.length;

			data.forEach(function (line, i) {
				// should not need s
				line.split('').forEach(function (char, j) {
					var color = colorsByBinding[char];
					pixel(baseOffsetX + j, baseOffsetY + i, color);
				});
			});
		}

		stringedSprites.forEach(function (stringedSprite, index) {
			var x = index % width;
			var y = Math.floor(index / width);

			paint(x, y, stringedSprite.data);
		});


		var dataURL = canvas.toDataURL('image/png');
		var image = new Image();
		image.src = dataURL;

		var spriteSheet = new SpriteSheet(image, width, width);


		var namedSprites = stringedSprites.map(function (stringedSprite, index) {
			var x = index % width;
			var y = Math.floor(index / width);

			return {
				name: stringedSprite.name,
				sprite: spriteSheet.getSprite(x, y)
			};
		});

		return namedSprites;
	};

	return SpriteSheetGenerator;
});
