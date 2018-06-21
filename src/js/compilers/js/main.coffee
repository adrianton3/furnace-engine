define [
	'Util'
], (
	Util
) ->
	'use strict'


	compileSpriteData = (data, colors) ->
		colorData = for line in data
			bytes = []

			for colorName in line
				color = colors.get colorName

				if color.format == 'rgb'
					bytes.push color.red, color.green, color.blue, 1
				else
					bytes.push color.red, color.green, color.blue, color.alpha

			btoa String.fromCharCode bytes...

		JSON.stringify colorData


	compilePlayerSprite = ({ name, data }, colors) ->
		"""
			'#{name}': {
				data: #{compileSpriteData data, colors},
			}
		"""


	compilePlayerSprites = (playerSprites, colors) ->
		lines = []
		push = lines.push.bind lines

		push "const player = {"

		playerSprites.forEach (playerSprite) ->
			push "#{compilePlayerSprite playerSprite, colors},"
			return

		push "}"

		lines.join '\n'


	compileObject = ({ name, data, blocking }, colors) ->
		"""
			'#{name}': {
				blocking: #{Boolean blocking},
				data: #{compileSpriteData data, colors},
			}
		"""


	compileObjects = (objects, colors) ->
		lines = []
		push = lines.push.bind lines

		push "const objects = {"

		objects.forEach (object) ->
			push "#{compileObject object, colors},"
			return

		push "}"

		lines.join '\n'


	compileLevelSize = (levels) ->
		"""
			{#{
				(
					levels.map ({ name, data }) ->
						"""
							'#{name}' : {
								x: #{data[0].length},
								y: #{data.length},
							}
						"""
				).join ',\n'
			}}
		"""


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


	compileSet = (setSpec, setDefinitions) ->
		if setSpec.elements?
			set = new Set setSpec.elements
		else
			operand1 = setDefinitions[setSpec.operand1]
			operand2 = setDefinitions[setSpec.operand2]

			set = new Set

			switch setSpec.operator
				when 'or'
					operand1.forEach (element) ->
						set.add element
						return

					operand2.forEach (element) ->
						set.add element
						return

				when 'and'
					operand1.forEach (element) ->
						if operand2.has element
							set.add element
						return

				when 'minus'
					operand1.forEach (element) ->
						if not operand2.has element
							set.add element
						return

		setDefinitions[setSpec.name] = set

		elements = (Array.from set).map (element) -> "'#{element}'"

		"'#{setSpec.name}': new Set([#{elements.join ', '}])"


	compileSets = (sets) ->
		lines = []
		push = lines.push.bind lines

		push "const sets = {"

		setDefinitions = {}
		sets.forEach (set) ->
			push "#{compileSet set, setDefinitions},"
			return

		push "}"

		lines.join '\n'


	isSetReference = Util.isCapitalized


	resolveItem = (reference) ->
		switch reference
			when '_terrain'
				'terrainItem'
			when '_inventory'
				'inventoryItem'
			else
				"'#{reference}'"


	makeList = ->
		elements = []

		{
			push: elements.push.bind elements
			join: elements.join.bind elements
		}


	compileNearRule = (rule) ->
		{ push, join } = makeList()

		terrainItemCondition = if isSetReference rule.inTerrainItemName
			"sets['#{rule.inTerrainItemName}'].has(terrainItem)"
		else
			"terrainItem === '#{rule.inTerrainItemName}'"

		push "if (#{terrainItemCondition}) {"

		if rule.outTerrainItemName?
			push "setTerrainItem(neighbor, #{resolveItem rule.outTerrainItemName})"

		if rule.healthDelta? and rule.healthDelta != 0
			push "state.player.health += #{rule.healthDelta}"

		push "}"

		join '\n'


	compileNearRules = (rules) ->
		{ push, join } = makeList()

		push 'function applyNearRules (position) {'

		push 'getNeighbors(position).forEach((neighbor) => {'

		push 'const terrainItem = getTerrainItem(neighbor)'

		ruleLines = makeList()
		rules.forEach (rule) ->
			ruleLines.push compileNearRule rule
			return
		push ruleLines.join ' else '

		push '})'

		push '}'

		join '\n'


	compileLeaveRule = (rule) ->
		{ push, join } = makeList()

		terrainItemCondition = if isSetReference rule.inTerrainItemName
			"sets['#{rule.inTerrainItemName}'].has(terrainItem)"
		else
			"terrainItem === '#{rule.inTerrainItemName}'"

		push "if (#{terrainItemCondition}) {"

		if rule.outTerrainItemName?
			push "setTerrainItem(prevPosition, #{resolveItem rule.outTerrainItemName})"

		push "}"

		join '\n'


	compileLeaveRules = (rules) ->
		{ push, join } = makeList()

		push 'function applyLeaveRules (prevPosition) {'

		push 'const terrainItem = getTerrainItem(prevPosition)'

		ruleLines = makeList()
		rules.forEach (rule) ->
			ruleLines.push compileLeaveRule rule
			return
		push ruleLines.join ' else '

		push '}'

		join '\n'


	compileEnterRule = (rule) ->
		{ push, join } = makeList()

		terrainItemCondition = if isSetReference rule.inTerrainItemName
			"sets['#{rule.inTerrainItemName}'].has(terrainItem)"
		else
			"terrainItem === '#{rule.inTerrainItemName}'"

		push "if (#{terrainItemCondition}) {"

		if rule.outTerrainItemName?
			push "setTerrainItem(position, #{resolveItem rule.outTerrainItemName})"

		if rule.give?
			rule.give.forEach ({ itemName, quantity }) ->
				push "addInventoryItem(#{resolveItem itemName}, #{quantity})"
				return

		if rule.healthDelta? and rule.healthDelta != 0
			push "state.player.health += #{rule.healthDelta}"

		if rule.teleport?
			push "state.player.position.level = '#{rule.teleport.levelName}'"
			push "state.player.position.x = #{rule.teleport.x}"
			push "state.player.position.y = #{rule.teleport.y}"

		push "}"

		join '\n'


	compileEnterRules = (rules) ->
		{ push, join } = makeList()

		push 'function applyEnterRules (position) {'

		push 'const terrainItem = getTerrainItem(position)'

		ruleLines = makeList()
		rules.forEach (rule) ->
			ruleLines.push compileEnterRule rule
			return
		push ruleLines.join ' else '

		push '}'

		join '\n'


	compileUseRule = (rule) ->
		{ push, join } = makeList()

		terrainItemCondition = if isSetReference rule.inTerrainItemName
			"sets['#{rule.inTerrainItemName}'].has(terrainItem)"
		else
			"terrainItem === '#{rule.inTerrainItemName}'"

		inventoryItemCondition = if isSetReference rule.inInventoryItemName
			"sets['#{rule.inInventoryItemName}'].has(inventoryItem.name)"
		else
			"inventoryItem.name === '#{rule.inInventoryItemName}'"

		push "if (#{terrainItemCondition} && #{inventoryItemCondition} && inventoryItem.count > 0) {"

		if rule.consume
			push "consumeInventoryItem()"

		if rule.outTerrainItemName?
			push "setTerrainItem(forwardPosition, #{resolveItem rule.outTerrainItemName})"

		if rule.give?
			rule.give.forEach ({ itemName, quantity }) ->
				push "addInventoryItem(#{resolveItem itemName}, #{quantity})"
				return

		if rule.healthDelta? and rule.healthDelta != 0
			push "state.player.health += #{rule.healthDelta}"

		if rule.teleport?
			push "state.player.position.level = '#{rule.teleport.levelName}'"
			push "state.player.position.x = #{rule.teleport.x}"
			push "state.player.position.y = #{rule.teleport.y}"

		push "}"

		join '\n'


	compileUseRules = (rules) ->
		{ push, join } = makeList()

		push 'function applyUseRules (position) {'

		push 'const forwardPosition = stepForward(position)'

		push 'const terrainItem = getTerrainItem(forwardPosition)'

		push 'const inventoryItem = getInventoryItem()'

		ruleLines = makeList()
		rules.forEach (rule) ->
			ruleLines.push compileUseRule rule
			return
		push ruleLines.join ' else '

		push '}'

		join '\n'


	compileData = (spec) ->
		params = Util.arrayToObject spec.params, 'name', 'parts'

		colorsIndexed = new Map
		spec.colors.forEach (color) ->
			colorsIndexed.set color.name, color
			return

		"""
			(() => {
			'use strict'

			#{compilePlayerSprites spec.player, colorsIndexed}
			#{compileObjects spec.objects, colorsIndexed}

			const objectSprites = {}
			const playerSprites = {}

			const params = {
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

			const state = {
				player: {
					position: {
						x: #{params['start_location'][0]},
						y: #{params['start_location'][1]},
						level: "#{params['start_location'][2]}",
						direction: 2,
					},
					inventory: {
						index: -1,
						items: [],
					},
				},
				levels: #{compileLevels spec.legend, spec.levels},
			}

			window.fur = window.fur || {}
			Object.assign(fur, {
				objects,
				player,
				objectSprites,
				playerSprites,
				state,
				params,
			})

			})()
		"""


	compileCode = (spec) ->
		"""
			(() => {
			'use strict'

			const {
				state,
				params,
				getTerrainItem,
				setTerrainItem,
				stepForward,
				getNeighbors,
				getInventoryItem,
				addInventoryItem,
				consumeInventoryItem,
			} = fur

			#{compileSets spec.sets}

			#{compileNearRules spec.nearRules}

			#{compileLeaveRules spec.leaveRules}

			#{compileEnterRules spec.enterRules}

			#{compileUseRules spec.useRules}

			window.fur = window.fur || {}
			Object.assign(fur, {
				applyNearRules,
				applyLeaveRules,
				applyEnterRules,
				applyUseRules,
			})

			})()
		"""

	{
		compileData
		compileCode
	}