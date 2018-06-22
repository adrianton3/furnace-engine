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
			const prevPosition = { ...state.player.position }

			let moveKey = false
			if (key === 'ArrowUp') {
				state.player.position.direction = 0
				state.player.position.y -= 1
				moveKey = true
			} else if (key === 'ArrowLeft') {
				state.player.position.direction = 1
				state.player.position.x -= 1
				moveKey = true
			} else if (key === 'ArrowDown') {
				state.player.position.direction = 2
				state.player.position.y += 1
				moveKey = true
			} else if (key === 'ArrowRight') {
				state.player.position.direction = 3
				state.player.position.x += 1
				moveKey = true
			} else if (key === 'a') {
				applyUseRules(state.player.position)
			}

			if (moveKey) {
				clamp(
					state.player.position,
					{ x: 0, y: 0 },
					levelSize[state.player.position.level],
				)

				if (
					prevPosition.x !== state.player.position.x ||
					prevPosition.y !== state.player.position.y
				) {
					applyLeaveRules(prevPosition)

					applyEnterRules(state.player.position)

					applyNearRules(state.player.position)
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