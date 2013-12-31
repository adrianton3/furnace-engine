define([], function () {
	'use strict';

	var Util = {};

	Util.findFirst = function (array, predicate) {
		for (var i = 0; i < array.length; i++) {
			if (predicate(array[i], i)) {
				return { element: array[i], index: i };
			}
		}
	};

	Util.removeFirst = function (array, predicate) {
		var firstMatch = Util.findFirst(array, predicate);
		array.splice(firstMatch.index, 1);
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

	Util.capitalize = function (string) {
		return string.substring(0, 1).toUpperCase() + string.substring(1);
	};

	Util.isCapitalized = function (string) {
		return string.substring(0, 1).toUpperCase() === string.substring(0, 1);
	};

	return Util;
});
