define([
	'tokenizer/Tokenizer',
	'parser/Parser',
	'prettyprinter/PrettyPrinter'
	], function(
		Tokenizer,
		Parser,
		PrettyPrinter
	) {
	'use strict';

	var inWorldEditor, outTokensEditor, outInterpretedEditor;
	function setupEditors() {
		inWorldEditor = CodeMirror.fromTextArea(document.getElementById('in'), {
            lineNumbers: true,
            styleActiveLine: true
        });
        inWorldEditor.setSize(400, 500);
        inWorldEditor.setOption('theme', 'cobalt');
        inWorldEditor.on('change', parse);

        outTokensEditor = CodeMirror.fromTextArea(document.getElementById('outtokens'), {
            lineNumbers: true,
            styleActiveLine: true,
            readOnly: true
        });
        outTokensEditor.setSize(400, 500);
        outTokensEditor.setOption('theme', 'cobalt');

        outInterpretedEditor = CodeMirror.fromTextArea(document.getElementById('outtree'), {
            lineNumbers: true,
            styleActiveLine: true,
            readOnly: true
        });
        outInterpretedEditor.setSize(400, 500);
        outInterpretedEditor.setOption('theme', 'cobalt');
	}

	var errorLine = null;
	function parse() {
		var inText = inWorldEditor.getValue();

		try {
			var tokens = Tokenizer.chop(inText);
			var outTokensText = tokens.join('\n');

			outTokensEditor.setValue(outTokensText);


			var tree = Parser.parse(tokens);
			var outTreeText = PrettyPrinter.print(tree);

			outInterpretedEditor.setValue(outTreeText);

			if (errorLine !== null) {
				inWorldEditor.removeLineClass(errorLine, 'background', 'line-error');
				errorLine = null;
			}

			document.getElementById('status').classList.add('ok');
			document.getElementById('status').classList.remove('err');
			document.getElementById('status').innerHTML = 'OK';
		} catch (ex) {
			if (ex.line !== undefined) {
				if (ex.line !== errorLine && errorLine !== null) {
					inWorldEditor.removeLineClass(errorLine, 'background', 'line-error');
				}
				errorLine = ex.line;
				inWorldEditor.addLineClass(errorLine, 'background', 'line-error');
			}

			document.getElementById('status').classList.add('err');
			document.getElementById('status').classList.remove('ok');
			document.getElementById('status').innerHTML = ex.message || ex;
		}
	}

    function run() {
        setupEditors();
        parse();
    }

	return { run: run };
});
