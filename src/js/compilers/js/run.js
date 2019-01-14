(() => {
	'use strict'

	const {
		params,
		state,
		objects,
		player,
		objectSprites,
		playerSprites,
		applyNearRules,
		applyLeaveRules,
		applyEnterRules,
		applyUseRules,
		drawWorld,
		updateWorld,
		clamp,
		canWalk,
	} = fur

	function init () {
		const { cameraSize, levelSize, tileSize, scale } = params

		function drawPixel (context, x, y, [r, g, b, a]) {
			context.fillStyle = `rgba(${r}, ${g}, ${b}, ${a})`
			context.fillRect(x * scale, y * scale, scale, scale)
		}

		function drawObject (context, data) {
			for (let y = 0; y < tileSize.y; y++) {
				const lineString = atob(data[y])

				const bytes = Array.from(lineString).map((char) =>
					char.charCodeAt(0)
				)

				for (let x = 0; x < tileSize.x; x++) {
					drawPixel(context, x, y, bytes.slice(x * 4, x * 4 + 4))
				}
			}
		}

		function generateSprites (specs, sprites) {
			Object.entries(specs).forEach(([name, object]) => {
				const canvas = document.createElement('canvas')
				canvas.width = tileSize.x * scale
				canvas.height = tileSize.y * scale

				const context = canvas.getContext('2d')
				drawObject(context, object.data)

				sprites[name] = canvas
			})
		}

		generateSprites(objects, objectSprites)
		generateSprites(player, playerSprites)

		const canvas = document.getElementById('can')
		canvas.width = cameraSize.x * tileSize.x * scale
		canvas.height = cameraSize.y * tileSize.y * scale

		const context = canvas.getContext('2d')

		window.addEventListener('keydown', ({ key }) => {
			const { position } = state.player
			const prevPosition = { ...position }

			if (key === 'ArrowUp') {
				position.direction = 0
				if (canWalk(objects, state, { x: position.x, y: position.y - 1 })) {
					position.y -= 1
				}
			} else if (key === 'ArrowLeft') {
				position.direction = 1
				if (canWalk(objects, state, { x: position.x - 1, y: position.y })) {
					position.x -= 1
				}
			} else if (key === 'ArrowDown') {
				position.direction = 2
				if (canWalk(objects, state, { x: position.x, y: position.y + 1 })) {
					position.y += 1
				}
			} else if (key === 'ArrowRight') {
				position.direction = 3
				if (canWalk(objects, state, { x: position.x + 1, y: position.y })) {
					position.x += 1
				}
			} else if (key === 'a') {
				applyUseRules(position)
			}

			if (
				prevPosition.x !== position.x ||
				prevPosition.y !== position.y
			) {
				clamp(
					position,
					{ x: 0, y: 0 },
					levelSize[position.level],
				)

				if (
					prevPosition.x !== position.x ||
					prevPosition.y !== position.y
				) {
					applyLeaveRules(prevPosition)

					applyEnterRules(position)

					applyNearRules(position)
				}
			}

			drawWorld(context)
		})

		return { context }
	}

	function loop ({ context }) {
		function loop() {
			updateWorld()
			drawWorld(context, params, state)

			// requestAnimationFrame(loop)
		}

		loop()
	}

	loop(init(params))
})()