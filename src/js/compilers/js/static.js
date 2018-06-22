(() => {
	'use strict'

	const {
		state,
		params,
		objectSprites,
		playerSprites,
	} = fur

	function stepForward (position) {
		const increment = [
			{ x:  0, y: -1 },
			{ x: -1, y:  0 },
			{ x:  0, y:  1 },
			{ x:  1, y:  0 },
		][position.direction]

		return {
			x: position.x + increment.x,
			y: position.y + increment.y,
		}
	}

	function isWithin (position, levelName) {
		const levelSize = params.levelSize[levelName]

		return position.x >= 0 && position.x < levelSize.x &&
			position.y >= 0 && position.y < levelSize.y
	}

	function getTerrainItem (position) {
		const { player, levels } = state
		const level = levels[player.position.level]

		return isWithin(position, player.position.level)
			? level[position.y][position.x]
			: null
	}

	function setTerrainItem (position, item) {
		const { player, levels } = state
		const level = levels[player.position.level]

		if (isWithin(position, player.position.level)) {
			level[position.y][position.x] = item
		}
	}

	function getInventoryItem () {
		const { items, index } = state.player.inventory

		return items.length <= 0
			? null
			: items[index]
	}

	function addInventoryItem (name, count) {
		const { items, index } = state.player.inventory

		const entry = items.find((entry) => entry.name === name)
		if (entry != null) {
			entry.count += count
		} else {
			items.push({ name, count })
		}

		if (index === -1) {
			state.player.inventory.index = 0
		}
	}

	function consumeInventoryItem () {
		const { items, index } = state.player.inventory

		if (items[index] != null && items[index].count > 0) {
			items[index].count--
		}
	}

	function getNeighbors (position) {
		return [
			{ x:  0, y: -1 },
			{ x: -1, y: -1 },
			{ x: -1, y:  0 },
			{ x: -1, y:  1 },
			{ x:  0, y:  1 },
			{ x:  1, y:  1 },
			{ x:  1, y:  0 },
			{ x:  1, y: -1 },
		].map(({ x, y }) => ({
			x: position.x + x,
			y: position.y + y,
		})).filter((position) =>
			isWithin(position, state.player.position.level)
		)
	}

	function clamp (a, minInclusive, maxExclusive) {
		a.x = Math.min(Math.max(minInclusive.x, a.x), maxExclusive.x - 1)
		a.y = Math.min(Math.max(minInclusive.y, a.y), maxExclusive.y - 1)

		return a
	}

	function drawSprite (context, sprite, { x, y }) {
		context.drawImage(sprite, x * sprite.width, y * sprite.height)
	}

	function drawLevel (context) {
		const { cameraSize, levelSize } = params
		const { player, levels } = state

		const cameraPosition = clamp({
			x: player.position.x - Math.floor(cameraSize.x / 2),
			y: player.position.y - Math.floor(cameraSize.y / 2),
		}, {
			x: 0,
			y: 0,
		}, {
			x: levelSize[player.position.level].x - cameraSize.x + 1,
			y: levelSize[player.position.level].y - cameraSize.y + 1,
		})

		const level = levels[player.position.level]

		for (let i = 0; i < cameraSize.y; i++) {
			for (let j = 0; j < cameraSize.x; j++) {
				drawSprite(
					context,
					objectSprites[level[i + cameraPosition.y][j + cameraPosition.x]],
					{ x: j, y: i }
				)
			}
		}
	}

	function drawPlayer (context) {
		const { cameraSize, levelSize } = params
		const { player } = state

		const cameraPosition = clamp({
			x: player.position.x - Math.floor(cameraSize.x / 2),
			y: player.position.y - Math.floor(cameraSize.y / 2),
		}, {
			x: 0,
			y: 0,
		}, {
			x: levelSize[player.position.level].x - cameraSize.x + 1,
			y: levelSize[player.position.level].y - cameraSize.y + 1,
		})

		drawSprite(
			context,
			playerSprites[['up', 'left', 'down', 'right'][player.position.direction]],
			{
				x: player.position.x - cameraPosition.x,
				y: player.position.y - cameraPosition.y,
			}
		)
	}

	function drawWorld (context) {
		drawLevel(context)
		drawPlayer(context)
	}

	function updateWorld () {

	}

	Object.assign(fur, {
		isWithin,
		stepForward,
		getTerrainItem,
		setTerrainItem,
		getInventoryItem,
		addInventoryItem,
		consumeInventoryItem,
		getNeighbors,
		drawWorld,
		updateWorld,
		clamp,
	})
})()