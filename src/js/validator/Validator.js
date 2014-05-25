define([], function () {
	'use strict';

	var Validator = {};

	Validator.validate = function (spec) {
		Validator.validate.colors(spec.colors);
		Validator.validate.player(spec.player, spec.colors);
		Validator.validate.objects(spec.objects, spec.colors);
		Validator.validate.sets(spec.sets, spec.objects);
        Validator.validate.nearRules(spec.nearRules, spec.sets, spec.objects);
        Validator.validate.leaveRules(spec.leaveRules, spec.sets, spec.objects);
        Validator.validate.enterRules(spec.enterRules, spec.sets, spec.objects);
		Validator.validate.useRules(spec.useRules, spec.sets, spec.objects);
		Validator.validate.legend(spec.legend, spec.objects);
		Validator.validate.levels(spec.levels, spec.legend);
	};

	Validator.validate.colors = function (colorsSpec) {
		// check if colors are in the right range
	};

	Validator.validate.player = function (playerSpec, colorsSpec) {
		//
	};

	Validator.validate.objects = function (objectsSpec, colorsSpec) {
		//
	};

	Validator.validate.sets = function (setSpec, objectsSpec) {
		//
	};

	Validator.validate.nearRules = function (rulesSpec, setSpec, objectsSpec) {
		//
	};

    Validator.validate.leaveRules = function (rulesSpec, setSpec, objectsSpec) {
        //
    };

    Validator.validate.enterRules = function (rulesSpec, setSpec, objectsSpec) {
        //
    };

    Validator.validate.useRules = function (rulesSpec, setSpec, objectsSpec) {
        //
    };

	Validator.validate.legend = function (legendSpec, objectsSpec) {
		//
	};

	Validator.validate.levels = function (levelsSpec, legendSpec) {
		//
	};

	return Validator;
});
