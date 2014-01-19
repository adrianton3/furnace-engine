require([
	'SystemBus',
	'Text',
	'Game',
	'tokenizer/Tokenizer',
	'parser/RDP',
	'KeyListener'
	], function (
		SystemBus,
		Text,
		Game,
		Tokenizer,
		RDP,
		KeyListener
	) {
	'use strict';

	var tree;
	var errorLine = null;
	var inWorldEditor;
	var game;

	function setupEditors() {
		inWorldEditor = CodeMirror.fromTextArea(document.getElementById('in'), {
            lineNumbers: true,
            styleActiveLine: true
        });
        inWorldEditor.setSize(400, 400);
        inWorldEditor.setOption('theme', 'cobalt');
        inWorldEditor.on('change', parse);
	}

	function parse() {
		var inText = inWorldEditor.getValue();

		try {
			var tokens = Tokenizer.chop(inText);
			tree = RDP.parse(tokens);

			if (errorLine !== null) {
				inWorldEditor.removeLineClass(errorLine, 'background', 'line-error');
				errorLine = null;
			}

			document.getElementById('status').classList.add('ok');
			document.getElementById('status').classList.remove('err');
			document.getElementById('status').innerHTML = 'OK';

			document.getElementById('compile').disabled = false;
		} catch (ex) {
			tree = null;
			document.getElementById('compile').disabled = true;

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

	function compile() {
		if (tree) {
			if (game) {
				game.cleanup();
			}

			game = new Game();
			game.init(tree);
			game.start();
		}
	}

	function setupGUI() {
		var compileButton = document.getElementById('compile');
		compileButton.addEventListener('click', compile);
	}

	function run() {
		setupEditors();
		setupGUI();

		SystemBus.addListener('resourcesLoaded', '', function() {
			Text.init();

			document.getElementById('can').tabIndex = 0;
			KeyListener.init(document.getElementById('can'));

			parse();
			compile();
		});
	}

	run();
});
