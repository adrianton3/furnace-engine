define([], function() {
	'use strict';

	function UseRule(
		inTerrainItem,
		inInventoryItem,
		outTerrainItem,
		outInventoryItems,
		consume,
		healthDelta,
		teleport,
		message,
		sound
	) {
		this.inTerrainItem = inTerrainItem;
		this.inInventoryItem = inInventoryItem;
		this.outTerrainItem = outTerrainItem;
		this.outInventoryItems = outInventoryItems;
		this.consume = consume;
		this.healthDelta = healthDelta;
		this.teleport = teleport;
		this.message = message;
		this.sound = sound;
	}

	return UseRule;
});
