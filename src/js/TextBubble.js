define([
    'Text',
    'Vec2',
    'con2d',
    'Util'
], function (
    Text,
    Vec2,
    con2d,
    Util
    ) {

	'use strict';

	function TextBubble() {
        this.position = new Vec2(8, 8);
        this.visible = true;
        this.text = '';
        this.length = -Infinity;
        this.lines = [];
    }

    TextBubble.prototype.hide = function () {
        this.visible = false;
        return this;
	};

    TextBubble.prototype.show = function () {
        this.visible = true;
        return this;
    };

    TextBubble.prototype.draw = function () {
        if (!this.visible) { return; }
        // clear bubble
        con2d.fillStyle = '#007B90';
        con2d.fillRect(this.position.x, this.position.y, this.length * 16 + 8, this.lines.length * 18 + 8);

        // draw the text, line by line
        for (var i = 0; i < this.lines.length; i++) {
            Text.drawAt(this.lines[i], this.position.x + 4, this.position.y + i * 18 + 4);
        }
    };

    TextBubble.prototype.setText = function (text) {
        this.text = text.toUpperCase();

        this.lines = this.text.split('\n')
            .map(function (line) { return line.trim() })

        this.length = Math.max.apply(
            null,
            this.lines.map(function (line) { return line.length })
        )

        var boxWidth = this.length * 16 + 8;
        this.position.x = Math.floor((con2d.canvas.width - boxWidth) / 2);

        return this;
    };

	return TextBubble;
});
