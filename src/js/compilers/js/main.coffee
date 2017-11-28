define ->
	'use strict'

	compileColor = (color) ->
		data = switch color.format
			when 'rgb'
				"[#{color.red}, #{color.green}, #{color.blue}, 1]"
			when 'rgba'
				"[#{color.red}, #{color.green}, #{color.blue}, #{color.alpha}]"

		"'#{color.name}': #{data}"


	compileColors = (colors) ->
		lines = []
		push = lines.push.bind lines

		push "const colors = {"

		colors.forEach (color) ->
			push "#{compileColor color},"
			return

		push "}"

		lines.join '\n'


	compileObject = ({ name, data, blocking }) ->
		colorData = for line in data
			for color in line
				"...colors['#{color}']"

		"""
			'#{name}': {
				data: [#{colorData}],
				blocking: #{blocking},
			}
		"""


	compileObjects = (objects) ->
		lines = []
		push = lines.push.bind lines

		push "const objects = {"

		objects.forEach (object) ->
			push "#{compileObject object},"
			return

		push "}"

		lines.join '\n'


	compile = (spec) ->
		"""
			#{compileColors spec.colors}
			#{compileObjects spec.objects}
		"""

	{
		compile
	}