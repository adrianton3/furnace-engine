define([
	'SystemBus',
	'Text',
	'Game',
	'tokenizer/Tokenizer',
	'parser/RDP',
	'KeyListener',
	'import-export/FromPng',
	'import-export/ToPng',
	'AjaxUtil'
	], function (
		SystemBus,
		Text,
		Game,
		Tokenizer,
		RDP,
		KeyListener,
		FromPng,
		ToPng,
		AjaxUtil
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

	function hide() {
		var editorDiv = document.getElementById('editor');
		editorDiv.style.display = 'none';

		var editButton = document.getElementById('edit');
		editButton.style.display = 'block';

		var hideButton = document.getElementById('hide');
		hideButton.style.display = 'none';

		var gameContDiv = document.getElementById('gamecont');
		gameContDiv.classList.add('centeredcont');

		var canvas = document.getElementById('can');
		canvas.focus();
	}

	function edit() {
		var editorDiv = document.getElementById('editor');
		editorDiv.style.display = 'block';

		var editButton = document.getElementById('edit');
		editButton.style.display = 'none';

		var hideButton = document.getElementById('hide');
		hideButton.style.display = 'block';

		var gameContDiv = document.getElementById('gamecont');
		gameContDiv.classList.remove('centeredcont');

		inWorldEditor.refresh();
	}

	function setupGUI() {
		var compileButton = document.getElementById('compile');
		compileButton.addEventListener('click', compile);

		var getUrlButton = document.getElementById('geturl');
		getUrlButton.addEventListener('click', setUrl);

		var exportAsPngButton = document.getElementById('exportaspng');
		exportAsPngButton.addEventListener('click', exportAsPng);

		var editButton = document.getElementById('edit');
		editButton.addEventListener('click', edit);

		var hideButton = document.getElementById('hide');
		hideButton.addEventListener('click', hide);
	}

	function setUrl() {
		var spec = inWorldEditor.getValue();
		var baseUrl = 'http://madflame991.github.io/furnace-engine/src/index.html';
		var encodedLevel = encodeURIComponent(spec);
		var url = baseUrl + '?spec=' + encodedLevel;

		var urlTextarea = document.getElementById('url');
		urlTextarea.value = url;
	}

	function exportAsPng() {
		var spec = inWorldEditor.getValue();
		var canvas = ToPng.encode(spec);

		var image = document.createElement('img');
		image.src = canvas.toDataURL();
		image.id = 'exported-spec';

		var existingImage = document.getElementById('exported-spec');
		if (existingImage) {
			existingImage.parentNode.removeChild(existingImage);
		}

		var container = document.getElementById('exported-container')
		container.innerHTML = 'Exported spec as image<br>';
		container.appendChild(image);
	}

	function checkUrl(callback) {
		var urlParams = purl(true).param();
		if (urlParams.spec) {
			inWorldEditor.setValue(urlParams.spec);
			callback();
		} else if (urlParams.png) {
			FromPng.decode(urlParams.png, function (text) {
				inWorldEditor.setValue(text);
				callback();
			});
		} else if (urlParams.text) {
			AjaxUtil.load(urlParams.text, function (text) {
				inWorldEditor.setValue(text);
				callback();
			});
		} else {
			callback();
		}
	}

	function run() {
		setupEditors();
		setupGUI();

		checkUrl(function () {
			Text.init();

			document.getElementById('can').tabIndex = 0;
			KeyListener.init(document.getElementById('can'));

			parse();
			compile();

			document.getElementById('can').focus();
		});
	}

	return { run: run };
});
