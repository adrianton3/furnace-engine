define([
	'Item',
	'SpriteSheetStore' // unneeded
	], function (
		Item,
		SpriteSheetStore
	) {
	'use strict';

	var Items = {};

	Items.collection = {};

	// this dissapears
	Items.populate = function() {
		var items = [
			new Item('grass', 'Grass', SpriteSheetStore.items.getSpriteAt(0, 0), true),
			new Item('dirt', 'Dirt', SpriteSheetStore.items.getSpriteAt(1, 0), true),
			new Item('bush', 'Bush', SpriteSheetStore.items.getSpriteAt(0, 1), false),
			new Item('stone', 'Stone', SpriteSheetStore.items.getSpriteAt(1, 1), false),
			new Item('pickaxe', 'PickAxe', SpriteSheetStore.items.getSpriteAt(2, 0), true)
		];

		items.forEach(function (item) { Items.collection[item.id] = item; });
	};

	return Items;
});
