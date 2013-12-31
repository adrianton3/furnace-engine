define([
	'tokenizer/Tokenizer',
	'tokenizer/IterableString',
	'tokenizer/TokEnd',
	'tokenizer/TokNum',
	'tokenizer/TokIdentifier',
	'tokenizer/TokStr',
	'tokenizer/TokLPar',
	'tokenizer/TokRPar',
	'tokenizer/TokKeyword',
	'tokenizer/TokWhitespace',
	'tokenizer/TokCommSL',
	'tokenizer/TokCommML',
	'tokenizer/TokenCoords'
	], function (
		Tokenizer,
		IterableString,
		TokEnd,
		TokNum,
		TokIdentifier,
		TokStr,
		TokLPar,
		TokRPar,
		TokKeyword,
		TokWhitespace,
		TokCommSL,
		TokCommML,
		TokenCoords
	) {
	'use strict';

	describe('Tokenizer', function() {
		describe('chop', function() {
			it('chops an empty specification', function() {
				expect(Tokenizer.chop('')).toEqual([new TokEnd(new TokenCoords(0, 1))]);
			});
		});
	});
});