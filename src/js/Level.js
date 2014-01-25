define([
	'Items',
	'Vec2'
	], function(
		Items,
		Vec2
	) {
	'use strict';

	function Level(data, levelDimensions, tileDimensions, uiOffset) {
		this.data = data;
		this.width = levelDimensions.x;
		this.height = levelDimensions.y;
		this.blockWidth = tileDimensions.x;
		this.blockHeight = tileDimensions.y;
		this.uiOffset = uiOffset || new Vec2(0, 0);
	}

	Level.prototype.get = function(x, y) {
		return this.data[y][x];
	};

	Level.prototype.set = function(x, y, item) {
		this.data[y][x] = item;
		return this;
	};

	Level.prototype.draw = function(camera, tick) {
		for (var i = 0; i < camera.dimensions.y; i++) {
			for (var j = 0; j < camera.dimensions.x; j++) {
				this.data[i + camera.position.y][j + camera.position.x].drawAt(
					this.uiOffset.x + j * this.blockWidth,
					this.uiOffset.y + i * this.blockHeight,
					tick
				);
			}
		}
	};

	Level.prototype.withinBounds = function(x, y) {
		return x >= 0 && x < this.width && y >= 0 && y < this.height;
	};

	return Level;
});
