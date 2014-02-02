define([], function() {
	'use strict';

	function EnterRule(
		inTerrainItem,
		outTerrainItem,
		outInventoryItems,
		healthDelta
	) {
		this.inTerrainItem = inTerrainItem;
		this.outTerrainItem = outTerrainItem;
		this.outInventoryItems = outInventoryItems;
		this.healthDelta = healthDelta;
		this.teleport = teleport;
		this.message = message;
	}

	return EnterRule;
});
