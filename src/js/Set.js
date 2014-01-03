define([], function () {
	'use strict';

	function Set() {
		this.elements = {};
	}

	Set.prototype.add = function(element) {
		this.elements[element] = true;
		return this;
	};

	Set.prototype.remove = function(element) {
		delete this.elements[element];
		return this;
	};

	Set.prototype.has = function(element) {
		return !!this.elements[element];
	};

	Set.prototype.keys = function() {
		return Object.keys(this.elements);
	};

	Set.prototype.copy = function() {
		var newSet = new Set();

		for (var key in this.elements) {
			newSet.add(key);
		}

		return newSet;
	};

	Set.prototype.union = function(that) {
		var newSet = this.copy();

		for (var key in that.elements) {
			newSet.add(key);
		}

		return newSet;
	};

	Set.prototype.intersection = function(that) {
		var newSet = new Set();

		for (var key in this.elements) {
			if (that.has(key)) {
				newSet.add(key);
			}
		}

		return newSet;
	};

	Set.prototype.difference = function(that) {
		var newSet = new Set();

		for (var key in this.elements) {
			if (!that.has(key)) {
				newSet.add(key);
			}
		}

		return newSet;
	};

	return Set;
});
