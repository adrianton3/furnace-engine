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
	'test/spec/backAndForth-test'
], function () {});