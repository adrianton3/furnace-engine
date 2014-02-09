define([], function () {
	'use strict';

	var Util = {};

	Util.maptree = function (tree, fun, predicate) {
		if (predicate(tree)) {
			return fun(tree);
		}

		if (tree instanceof Array) {
			return tree.map(function (elem) {
				return Util.maptree(elem, fun, predicate);
			});
		} else if (typeof tree === 'object') {
			var newObj = {};
			for (var key in tree) {
				newObj[key] = Util.maptree(tree[key], fun, predicate);
			}
			return newObj;
		}
	};

	Util.findFirst = function (array, predicate) {
		for (var i = 0; i < array.length; i++) {
			if (predicate(array[i], i)) {
				return { element: array[i], index: i };
			}
		}
	};

	Util.removeFirst = function (array, predicate) {
		var firstMatch = Util.findFirst(array, predicate);
		if (firstMatch) {
			array.splice(firstMatch.index, 1);
		}
	};

	Util.remove = function (array, element) {
		Util.removeFirst(array, function (entry) {
			return entry === element;
		});
	};

	Util.objectToArray = function (object, nameProperty, dataProperty) {
		var array = [];
		for (var key in object) {
			var entry = {};
			entry[nameProperty] = key;
			entry[dataProperty] = object[key];

			array.push(entry);
		}
		return array;
	};

	Util.arrayToObject = function (array, nameProperty, dataProperty) {
		var object = {};

		array.forEach(function (element) {
			object[element[nameProperty]] = element[dataProperty];
		});

		return object;
	};

	Util.mapOnKeys = function (object, fun) {
		var ret = {};
		for (var key in object) {
			ret[key] = fun(object[key]);
		}
		return ret;
	};

	Util.groupBy = function (array, fun) {
		var groups = {};
		array.forEach(function (element) {
			var ret = fun(element);
			if (!groups[ret]) {
				groups[ret] = [];
			}
			groups[ret].push(element);
		});
		return groups;
	};

	Util.capitalize = function (string) {
		return string.substring(0, 1).toUpperCase() + string.substring(1);
	};

	Util.isCapitalized = function (string) {
		return string.substring(0, 1).toUpperCase() === string.substring(0, 1);
	};

	return Util;
});
