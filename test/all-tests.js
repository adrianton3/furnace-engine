require.config({
	baseUrl: '../src/js',
	paths: {
		test: '../../test'
	}
});

define([
    'test/spec/Tokenizer-test',
	'test/spec/FromPng-test',
	'test/spec/ToPng-test',
	'test/spec/backAndForth-test',
	'test/spec/Tokenizer-test',
	'test/spec/Parser-test',
	'test/spec/Validator-test',
	'test/spec/ValueExtractor-test'
], function () {});