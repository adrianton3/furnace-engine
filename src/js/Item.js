define([], function() {
	'use strict';

	function Item(id, name, sprites, blocking) {
		this.id = id;
		this.name = name;
		this.sprites = sprites;
		this.blocking = blocking;
	}

	Item.prototype.drawAt = function(x, y, tick) {
		if (tick !== undefined) {
			tick = Math.min(tick, this.sprites.length - 1);
		} else {
			tick = 0;
		}
		//tick = tick || (this.sprites.length - 1);
		this.sprites[tick].drawAt(x, y);
	};

	return Item;
});
