define [
	'Util'
], (
	Util
) ->
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

		push "var colors = {"

		colors.forEach (color) ->
			push "#{compileColor color},"
			return

		push "}"

		lines.join '\n'


	compileObject = ({ name, data, blocking }) ->
		colorData = for line in data
			for color in line
				"colors['#{color}']"

		"""
			'#{name}': {
				data: [#{colorData}],
				blocking: #{blocking},
			}
		"""


	compileObjects = (objects) ->
		lines = []
		push = lines.push.bind lines

		push "var objects = {"

		objects.forEach (object) ->
			push "#{compileObject object},"
			return

		push "}"

		lines.join '\n'


	compileLevelSize = (levels) ->
		(
			levels.map ({ name, data }) ->
				"""
					'#{name}' : {
						x: #{data[0].length},
						y: #{data.length},
					}
				"""
		).join ',\n'


	compileLevel = (legend, { name, data }) ->
		lines = data.map (line) ->
			Array::map.call line, (item) ->
				legend[item]

		"'#{name}': #{JSON.stringify lines}"


	compileLevels = (legend, levels) ->
		legendIndexed = Util.arrayToObject legend, 'name', 'objectName'

		lines = []
		push = lines.push.bind lines

		push "{"

		levels.forEach (level) ->
			push "#{compileLevel legendIndexed, level},"
			return

		push "}"

		lines.join '\n'


	compile = (spec) ->
		params = Util.arrayToObject spec.params, 'name', 'parts'

		"""
			#{compileColors spec.colors}
			#{compileObjects spec.objects}

			var sprites = {}

			var params = {
				scale: #{params['scale'][0]},
				tileSize: {
					x: #{spec.objects[0].data[0].length},
					y: #{spec.objects[0].data.length},
				},
				cameraSize: {
					x: #{params['camera'][0]},
					y: #{params['camera'][1]},
				},
				levelSize: #{compileLevelSize spec.levels},
			}

			// state
			var state = {
				player: {
					position: {
						x: #{params['start_location'][0]},
						y: #{params['start_location'][1]},
						level: "#{params['start_location'][2]}",
					},
				},
				levels: #{compileLevels spec.legend, spec.levels},
			}
		"""

	{
		compile
	}