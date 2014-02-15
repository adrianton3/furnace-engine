define([], function() {
	'use strict';

	function NearRule(
		inTerrainItem,
		outTerrainItem,
		healthDelta
	) {
		this.inTerrainItem = inTerrainItem;
		this.outTerrainItem = outTerrainItem;
		this.healthDelta = healthDelta;
	}

	return NearRule;
});
