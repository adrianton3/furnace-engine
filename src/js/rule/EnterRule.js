define([], function() {
	'use strict';

	function EnterRule(
		inTerrainItem,
		outTerrainItem,
		outInventoryItems,
		healthDelta,
		teleport,
		message,
        checkpoint
	) {
		this.inTerrainItem = inTerrainItem;
		this.outTerrainItem = outTerrainItem;
		this.outInventoryItems = outInventoryItems;
		this.healthDelta = healthDelta;
		this.teleport = teleport;
		this.message = message;
        this.checkpoint = checkpoint;
	}

	return EnterRule;
});
