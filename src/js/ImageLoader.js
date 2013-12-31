define(['All'], function (All) {
	'use strict';

	function ImageLoader(basePath, imageNames, onComplete) {
		var all = new All(imageNames.length, function() { onComplete(namedImages); });
		var callback = all.getCallback();

		var namedImages = imageNames.map(function (imageName) {
			var image = new Image();
			image.src = basePath + imageName + '.png'; // assuming they're always pngs
			image.onload = callback;
			return { name: imageName, image: image };
		});
	}

	return ImageLoader;
});
