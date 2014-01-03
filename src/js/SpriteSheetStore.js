define([
	'ImageLoader',
	'SpriteSheet',
	'SystemBus'
	], function (
		ImageLoader,
		SpriteSheet,
		SystemBus
	) {
	'use strict';

	// this whole class dissapears

	var SpriteSheetStore = {};

	// ...
	var imageSubdivs = {
		'text': { horizontal: 10, vertical: 1 }
	};

	var imagePaths = Object.keys(imageSubdivs);

	new ImageLoader('res/', imagePaths, function (namedImages) {
		namedImages.forEach(function (namedImage) {
			SpriteSheetStore[namedImage.name] = new SpriteSheet(
				namedImage.image,
				imageSubdivs[namedImage.name].horizontal,
				imageSubdivs[namedImage.name].vertical
			);
		});
		SystemBus.emit('resourcesLoaded');
	});

	return SpriteSheetStore;
});
