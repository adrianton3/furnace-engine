define(['Util'], function (Util) {
	'use strict';

	function Bus() {
		this.channels = {};
	}

	Bus.prototype.addListener = function(channel, id, callback) {
		if (!this.channels[channel]) {
			this.channels[channel] = [];
		}
		this.channels[channel].push({ id: id, callback: callback });
	};

	Bus.prototype.emit = function(channel, data) {
		if (this.channels[channel]) {
			this.channels[channel].forEach(function(listener) {
				listener.callback(data);
			});
		}
	};

	Bus.prototype.removeListener = function(channel, id) {
		Util.removeFirst(this.channels[channel], function(listener) { return listener.id === id; });
	};

	Bus.prototype.removeChannel = function(channel) {
		delete this.channels[channel];
	};

	return Bus;
});
