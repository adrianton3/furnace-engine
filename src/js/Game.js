define([
	'SystemBus',
	'SpriteSheetStore', //
	'World',
	'KeyListener',
	'Text',
	'tokenizer/Tokenizer',
	'parser/RDP',
	'generator/Generator'
	], function(
		SystemBus,
		SpriteSheetStore,
		World,
		KeyListener,
		Text,
		Tokenizer,
		RDP,
		Generator
	) {
	'use strict';

	function Game() {
		this.world = null;
	}

	Game.prototype.init = function() {
		var inTextArea = document.getElementById('in');
		var stringedWorld = inTextArea.value;
		var tokens = Tokenizer.chop(stringedWorld);
		var tree = RDP.parse(tokens);

		// prettyprint it to check

		this.world = Generator.generate(tree);
		this.world.init();
	};

	Game.prototype.start = function() {
		//KeyListener.init(document.getElementById('can'));
		KeyListener.init(document);

		var loop = function () {
			this.world.update();
			this.world.draw();
			window.requestAnimationFrame(loop);
		}.bind(this);

		loop();
	};

	function run() {
		SystemBus.addListener('resourcesLoaded', '', function() {
			Text.init();

			var game = new Game();
			game.init();
			game.start();
		});
	}

	run();

	return Game;
});
