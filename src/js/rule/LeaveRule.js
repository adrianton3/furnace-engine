define([], function() {
	'use strict';

	function LeaveRule(
		inTerrainItem,
		outTerrainItem
	) {
		this.inTerrainItem = inTerrainItem;
		this.outTerrainItem = outTerrainItem;
	}

	return LeaveRule;
});
