require([
	'tokenizer/Tokenizer',
	'parser/RDP',
	'prettyprinter/PrettyPrinter',
	'generator/SpriteSheetGenerator'
	], function(
		Tokenizer,
		RDP,
		PrettyPrinter,
		SpriteSheetGenerator
	) {
	'use strict';

	var inTextArea = document.getElementById('in');
	var outTokensTextArea = document.getElementById('outtokens');
	var outTreeTextArea = document.getElementById('outtree');

	var button = document.getElementById('but');

	inTextArea.addEventListener('keyup', parse);

	parse();

	function parse() {
		var inText = inTextArea.value;


		var tokens = Tokenizer.chop(inText);
		var outTokensText = tokens.join('\n');

		outTokensTextArea.value = outTokensText;


		var tree = RDP.parse(tokens);
		var outTreeText = PrettyPrinter.print(tree);

		outTreeTextArea.value = outTreeText;
	}
});
