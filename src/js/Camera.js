define([], function () {
	'use strict';

	function Camera(position, dimensions) {
		this.position = position;
		this.dimensions = dimensions;
	}

	Camera.prototype.centerOn = function (x, y, levelWidth, levelHeight) {
		this.position.x = x - Math.floor(this.dimensions.x / 2);
		this.position.y = y - Math.floor(this.dimensions.y / 2);

		if (this.position.x < 0) {
			this.position.x = 0;
		} else if (this.position.x >= levelWidth - this.dimensions.x) {
			this.position.x = levelWidth - this.dimensions.x;
		}

		if (this.position.y < 0) {
			this.position.y = 0;
		} else if (this.position.y >= levelHeight - this.dimensions.y) {
			this.position.y = levelHeight - this.dimensions.y;
		}
	};

	return Camera;
});
