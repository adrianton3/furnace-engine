define([], function() {
	'use strict';

	function Rule(inTerrainItem, inInventoryItem, outTerrainItem, outInventoryItems, healthDelta) {
		this.inTerrainItem = inTerrainItem;
		this.inInventoryItem = inInventoryItem;
		this.outTerrainItem = outTerrainItem;
		this.outInventoryItems = outInventoryItems;
		this.healthDelta = healthDelta;
	}

	return Rule;
});
