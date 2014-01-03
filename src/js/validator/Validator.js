define([], function() {
	'use strict';

	var Validator = {};

	Validator.validate = function(spec) {
		Validator.validate.colors(spec.colors);
		Validator.validate.player(spec.player, spec.colors);
		Validator.validate.objects(spec.objects, spec.colors);
		Validator.validate.sets(spec.sets, spec.objects);
		Validator.validate.rules(spec.rules, spec.sets, spec.objects);
		Validator.validate.legend(spec.legend, spec.objects);
		Validator.validate.levels(spec.levels, spec.legend);
	};

	Validator.validate.colors = function(colorsSpec) {
		// check if colors are in the right range
	};

	Validator.validate.player = function(playerSpec, colorsSpec) {
		//
	};

	Validator.validate.objects = function(objectsSpec, colorsSpec) {
		//
	};

	Validator.validate.sets = function(setSpec, objectsSpec) {
		//
	};

	Validator.validate.rules = function(rulesSpec, setSpec, objectsSpec) {
		//
	};

	Validator.validate.legend = function(legendSpec, objectsSpec) {
		//
	};

	Validator.validate.levels = function(levelsSpec, legendSpec) {
		//
	};

	return Validator;
});
