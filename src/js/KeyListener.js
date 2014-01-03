define(['SystemBus'], function (SystemBus) {
	'use strict';

	var keyState = {};

	function onKeyDown(e) {
		e.preventDefault();
		e.stopPropagation();

		if (!keyState[e.which]) {
			SystemBus.emit('keydown', { key: e.which });
		}
		keyState[e.which] = true;
	}

	function onKeyUp(e) {
		e.preventDefault();
		e.stopPropagation();

		if (keyState[e.which]) {
			SystemBus.emit('keyup', { key: e.which });
		}
		keyState[e.which] = false;
	}



	var KeyListener = {};

	KeyListener.init = function (domElement) {
		domElement.addEventListener('keydown', onKeyDown);
		domElement.addEventListener('keyup', onKeyUp);
	};

	return KeyListener;
});
