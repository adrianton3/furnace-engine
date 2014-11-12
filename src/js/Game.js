define([
	'SystemBus',
	'World',
	'generator/Generator'
	], function(
		SystemBus,
		World,
		Generator
	) {
	'use strict';

	function Game() {
		this.world = null;
		this.requestId = null;
	}

	Game.prototype.init = function (tree) {
		this.world = Generator.generate(tree);
		this.world.init();
	};

	Game.prototype.start = function () {
		var loop = function () {
			this.world.update();
			//this.world.draw();
			this.requestId = window.requestAnimationFrame(loop);
		}.bind(this);

		loop();
	};

	Game.prototype.cleanup = function () {
		window.cancelAnimationFrame(this.requestId);
		SystemBus.reset();
	};

	return Game;
});
