define([], function() {
	'use strict';

	function Rule(
		inTerrainItem,
		inInventoryItem,
		outTerrainItem,
		outInventoryItems,
		consume,
		healthDelta
	) {
		this.inTerrainItem = inTerrainItem;
		this.inInventoryItem = inInventoryItem;
		this.outTerrainItem = outTerrainItem;
		this.outInventoryItems = outInventoryItems;
		this.consume = consume;
		this.healthDelta = healthDelta;
	}

	return Rule;
});
