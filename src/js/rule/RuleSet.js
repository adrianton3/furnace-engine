define([
	'Set',
	'Util'
	], function (
		Set,
		Util
	) {
	'use strict';

	function RuleSet(rules, setsByName) {
		this.rules = rules || [];
		this.setsByName = setsByName || {};
	}

	RuleSet.prototype.getRuleFor = function(inTerrainItem, inInventoryItem) {
		var firstMatchingRule = Util.findFirst(this.rules, function(rule) {

			var terrainMatch;
			if (Util.isCapitalized(rule.inTerrainItem)) {
				terrainMatch = this.setsByName[rule.inTerrainItem].has(inTerrainItem);
			} else {
				terrainMatch = rule.inTerrainItem === inTerrainItem;
			}

			if (!terrainMatch) {
				return false;
			}

			if (!inInventoryItem) {
				return terrainMatch;
			}

			var inventoryMatch;
			if (Util.isCapitalized(rule.inInventoryItem)) {
				inventoryMatch = this.setsByName[rule.inInventoryItem].has(inInventoryItem);
			} else {
				inventoryMatch = rule.inInventoryItem === inInventoryItem;
			}

			return terrainMatch && inventoryMatch;
		}.bind(this));

		if (firstMatchingRule) {
			return firstMatchingRule.element;
		}
	};

	return RuleSet;
});
