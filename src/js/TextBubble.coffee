define [
	'Text'
	'Vec2'
	'con2d'
], (
	Text
	Vec2
	con2d
) ->
	'use strict'

	TextBubble = ->
		@position = new Vec2 8, 8
		@visible = true
		@length = -Infinity
		@lines = []
		return


	TextBubble::hide = ->
		@visible = false
		@


	TextBubble::show = ->
		@visible = true
		@


	TextBubble::draw = ->
		return if not @visible

		# clear bubble
		con2d.fillStyle = '#007B90'
		con2d.fillRect @position.x, @position.y, @length * 16 + 8, @lines.length * 18 + 8

		# draw the text, line by line
		@lines.forEach (line, index) =>
			Text.drawAt line, @position.x + 4, @position.y + index * 18 + 4
			return

		return


	TextBubble::setText = (text) ->
		@lines = text.split '\n'
			.map (line) -> line.trim()

		@length = Math.max @lines.map(({ length }) -> length)...

		boxWidth = @length * 16 + 8
		@position.x = (con2d.canvas.width - boxWidth) // 2
		@


	TextBubble