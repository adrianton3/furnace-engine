define [
	'tokenizer/Tokenizer'
	'parser/TokenList'
	'parser/Parser'
	'validator/Validator',
	'test/CustomMatchers'
], (
	Tokenizer
	TokenList
	Parser
	Validator
	CustomMatchers
) ->
  describe 'Validator', ->
		chop = (str) ->
			new TokenList Tokenizer.chop str

		beforeEach ->
			jasmine.addMatchers CustomMatchers

		describe 'PARAM', ->
			stdLevelsSpec = Parser.parseLevels chop '''
					LEVELS

					level1
					aaabb
					bbaaa
				'''

			validate = (str) ->
				Validator.validateParam (Parser.parseParams chop str), stdLevelsSpec

			it 'validates a correct param spec', ->
				expect(-> validate '''
					PARAM
					camera 11 9
					scale 8
					start_location 1 1 level1
					inventory_size_max 5
					health_max 0
					COLORS
				''').not.toThrow()

			it 'throws an error if camera parts are missing or too many', ->
				expect(-> validate '''
					PARAM
					camera
					COLORS
				''').toThrowWithMessage 'Camera must have a width and a height'

				expect(-> validate '''
					PARAM
					camera 10 20 30
					COLORS
				''').toThrowWithMessage 'Camera must have a width and a height'

			it 'throws an error if camera parts are not numbers or are less than 5', ->
				expect(-> validate '''
					PARAM
					camera 10 b
					COLORS
				''').toThrowWithMessage 'Camera height value must be at least 5'

				expect(-> validate '''
					PARAM
					camera 3 10
					COLORS
				''').toThrowWithMessage 'Camera width value must be at least 5'

			it 'throws an error if scale parts are missing or too many', ->
				expect(-> validate '''
					PARAM
					scale
					COLORS
				''').toThrowWithMessage 'Scale must have a value'

				expect(-> validate '''
					PARAM
					scale 10 20
					COLORS
				''').toThrowWithMessage 'Scale must have a value'

			it 'throws an error if start_location parts are missing or too many', ->
				expect(-> validate '''
					PARAM
					start_location
					COLORS
				''').toThrowWithMessage 'Start location must have a column, a line and a level name'

				expect(-> validate '''
					PARAM
					start_location 10 20 30 40
					COLORS
				''').toThrowWithMessage 'Start location must have a column, a line and a level name'

			it 'throws an error if start_location level is not defined', ->
				expect(-> validate '''
					PARAM
					start_location 1 1 level2
					COLORS
				''').toThrowWithMessage 'Start level is not defined'

			it 'throws an error if start_location coordinates are out of level bounds', ->
				expect(-> validate '''
					PARAM
					start_location -1 1 level1
					COLORS
				''').toThrowWithMessage 'Start location coordinates must be within level bounds'

				expect(-> validate '''
					PARAM
					start_location 1 10 level1
					COLORS
				''').toThrowWithMessage 'Start location coordinates must be within level bounds'

			it 'throws an error if inventory_size_max parts are missing or too many', ->
				expect(-> validate '''
					PARAM
					inventory_size_max
					COLORS
				''').toThrowWithMessage 'Inventory_size_max must have a value'

				expect(-> validate '''
					PARAM
					inventory_size_max 10 20
					COLORS
				''').toThrowWithMessage 'Inventory_size_max must have a value'

			it 'throws an error if health_max parts are missing or too many', ->
				expect(-> validate '''
					PARAM
					health_max
					COLORS
				''').toThrowWithMessage 'Health_max must have a value'

				expect(-> validate '''
					PARAM
					health_max 10 20
					COLORS
				''').toThrowWithMessage 'Health_max must have a value'


		describe 'COLORS', ->
			validate = (str) ->
				Validator.validateColors Parser.parseColors chop str

			it 'validates a correct color spec', ->
				expect(validate '''
					COLORS
					a rgb 11 22 33
					PLAYER
				''').toBeTruthy()

			it 'throws an error if components are not numbers', ->
				expect(-> validate '''
					COLORS
					a rgb 111 2ab cde
					PLAYER
				''').toThrow()

			it 'throws an error if the bindings are too long', ->
				expect(-> validate '''
					COLORS
					aa rgb 11 22 33
					PLAYER
				''').toThrow()

			it 'throws an error if the ranges are not right', ->
				expect(-> validate '''
					COLORS
					a rgb 111 222 333
					PLAYER
				''').toThrow()

			it 'throws an error if the range for the alpha channel is not right', ->
				expect(-> validate '''
					COLORS
					a rgba 11 22 33 2
					PLAYER
				''').toThrow()

			it 'throws an error if the range for hue is not right', ->
				expect(-> validate '''
					COLORS
					a hsl 361 22 33
					PLAYER
				''').toThrow()

			it 'throws an error if the range for saturation is not right', ->
				expect(-> validate '''
					COLORS
					a hsl 11 101 33
					PLAYER
				''').toThrow()

			it 'throws an error if the range for lightness is not right', ->
				expect(-> validate '''
					COLORS
					a hsl 11 22 101
					PLAYER
				''').toThrow()

		describe 'PLAYER', ->
			getColorsSpec = (str) -> Parser.parseColors chop str

			stdColorsSpec = getColorsSpec '''
				COLORS
				a rgb 11 22 33
				b rgb 44 55 66
				PLAYER
			'''

			validate = (str) ->
				Validator.validatePlayer (Parser.parsePlayer chop str), stdColorsSpec

			it 'validates a correct player spec', ->
				expect(-> validate '''
					PLAYER
					up
					aa
					ab

					left
					aa
					ba

					down
					aa
					aa

					right
					aa
					aa

					health
					aa
					aa

					OBJECTS
				''').not.toThrow()

			it 'throws an error if not all the required frames are defined', ->
				expect(-> validate '''
					PLAYER
					up
					aa
					ab

					left
					aa
					ba

					OBJECTS
				''').toThrow()

			it 'throws an error if the frames are of different sizes', ->
				expect(-> validate '''
					PLAYER
					up
					aa
					ab

					left
					aa
					baa

					down
					aa
					aa

					right
					aa
					aa

					health
					aa
					aa

					OBJECTS
				''').toThrow()

			it 'throws an error if the frames use undefined colors', ->
				expect(-> validate '''
					PLAYER
					up
					aa
					ab

					left
					aa
					ba

					down
					aa
					ac

					right
					aa
					aa

					health
					aa
					aa

					OBJECTS
				''').toThrow()

			it 'throws an error if the same frame has been declared twice', ->
				expect(-> validate '''
					PLAYER
					up
					aa
					ab

					left
					aa
					ba

					down
					aa
					aa

					right
					aa
					aa

					health
					aa
					aa

					down
					aa
					aa

					OBJECTS
				''').toThrow()

		describe 'OBJECTS', ->
			getColorsSpec = (str) -> Parser.parseColors chop str

			stdColorsSpec = getColorsSpec '''
				COLORS
				a rgb 11 22 33
				b rgb 44 55 66
				PLAYER
			'''

			validate = (str) ->
				Validator.validateObjects (Parser.parseObjects chop str), stdColorsSpec

			it 'validates a correct objects spec', ->
				expect(-> validate '''
					OBJECTS
					stone
					aa
					ab

					dirt
					aa
					ba

					SETS
				''').not.toThrow()

			it 'throws an error if the frames are of different sizes', ->
				expect(-> validate '''
					OBJECTS
					stone
					aa
					ab

					dirt
					aa
					baa

					SETS
				''').toThrow()

			it 'throws an error if the frames use undefined colors', ->
				expect(-> validate '''
					OBJECTS
					stone
					aa
					ab

					dirt
					aa
					bc

					SETS
				''').toThrow()

			it 'throws an error if the same object was declared twice', ->
				expect(-> validate '''
					OBJECTS
					stone
					aa
					ab

					dirt
					aa
					ba

					stone
					aa
					ba

					SETS
				''').toThrow()

		describe 'SETS', ->
			stdObjectSpec = Parser.parseObjects chop '''
					OBJECTS

					stone
					aa
					ab

					dirt
					aa
					ac

					sand
					aa
					ad

					SETS
				'''

			validate = (setsSource) ->
				setsSpec = Parser.parseSets chop setsSource
				Validator.validateSets setsSpec, stdObjectSpec

			it 'validates a correct sets spec', ->
				expect(-> validate '''
						SETS
						A = stone dirt
						B = stone sand

						NEARRULES
					''').not.toThrow()

			it 'throws an error if bound set is not capitalized', ->
				expect(-> validate '''
						SETS
						Aa = stone dirt
						bb = stone sand

						NEARRULES
					''').toThrow()

			it 'throws an error if bound set was already bound', ->
				expect(-> validate '''
						SETS
						A = stone dirt
						A = stone sand

						NEARRULES
					''').toThrow()

			it 'throws an error when referencing undefined objects', ->
				expect(-> validate '''
						SETS
						A = stone dirt
						B = sand marble

						NEARRULES
					''').toThrowWithMessage 'Object marble was not defined'

			it 'throws an error when referencing sets in enumerations', ->
				expect(-> validate '''
						SETS
						A = stone dirt
						B = sand A

						NEARRULES
					''').toThrowWithMessage 'Elements of an enumeration must be objects'

			it 'throws an error when referencing objects as operands', ->
				expect(-> validate '''
						SETS
						A = stone dirt
						B = A and sand

						NEARRULES
					''').toThrowWithMessage 'Can only perform set operations on sets'

			it 'throws an error when referencing undefined sets', ->
				expect(-> validate '''
						SETS
						A = stone dirt
						B = A and C
						C = sand

						NEARRULES
					''').toThrowWithMessage 'Set C was not defined'

			it 'throws an error when defining self-referential sets', ->
				expect(-> validate '''
						SETS
						A = stone dirt
						B = A and B

						NEARRULES
					''').toThrowWithMessage 'Cannot reference a set in its own definition'


		describe 'SOUNDS', ->
			validate = (soundsSource) ->
				soundsSpec = Parser.parseSounds chop soundsSource
				Validator.validateSounds soundsSpec

			it 'validates a correct sounds spec', ->
				expect(-> validate '''
						SOUNDS
						001234 asd
						015678 fgh

						NEARRULES
					''').not.toThrow()

			it 'throws an error if the same binding is used twice', ->
				expect(-> validate '''
						SOUNDS
						001234 asd
						015678 asd

						NEARRULES
					''').toThrowWithMessage 'Sound binding already declared'


		describe 'NEARRULES', ->
			stdObjectsSpec = Parser.parseObjects chop '''
					OBJECTS

					stone
					aa
					ab

					dirt
					aa
					ac

					sand
					aa
					ad

					SETS
				'''

			stdSetsSpec = Parser.parseSets chop '''
					SETS
					A = stone dirt
					NEARRULES
				'''

			validate = (nearRulesSource) ->
				nearRulesSpec = Parser.parseNearRules chop nearRulesSource
				Validator.validateNearRules nearRulesSpec, stdObjectsSpec, stdSetsSpec

			it 'validates a correct near rules spec', ->
				expect(-> validate '''
					NEARRULES
					stone -> dirt ; hurt 10
					A -> stone ; heal 10
					A -> _terrain
					LEAVERULES
				''').not.toThrow()

			it 'throws an error when referencing undefined objects in the right hand side', ->
				expect(-> validate '''
					NEARRULES
					marble -> dirt
					LEAVERULES
				''').toThrowWithMessage 'Object marble was not defined'

			it 'throws an error when referencing undefined sets in the right hand side', ->
				expect(-> validate '''
					NEARRULES
					D -> dirt
					LEAVERULES
				''').toThrowWithMessage 'Set D was not defined'

			it 'throws an error when referencing undefined objects in the left hand side', ->
				expect(-> validate '''
					NEARRULES
					stone -> marble
					LEAVERULES
				''').toThrowWithMessage 'Object marble was not defined'

			it 'throws an error when referencing sets in the left hand side', ->
				expect(-> validate '''
					NEARRULES
					stone -> A
					LEAVERULES
				''').toThrowWithMessage 'Sets are not allowed in the left hand side of rules'

			it 'throws an error if heal quantity is not a number', ->
				expect(-> validate '''
					NEARRULES
					stone -> dirt ; heal asd
					LEAVERULES
				''').toThrowWithMessage 'Heal quantity must be a number'

			it 'throws an error if hurt quantity is not a number', ->
				expect(-> validate '''
					NEARRULES
					stone -> dirt ; hurt asd
					LEAVERULES
				''').toThrowWithMessage 'Hurt quantity must be a number'


		describe 'LEAVERULES', ->
			stdObjectsSpec = Parser.parseObjects chop '''
					OBJECTS

					stone
					aa
					ab

					dirt
					aa
					ac

					sand
					aa
					ad

					SETS
				'''

			stdSetsSpec = Parser.parseSets chop '''
					SETS
					A = stone dirt
					NEARRULES
				'''

			validate = (leaveRulesSource) ->
				leaveRulesSpec = Parser.parseLeaveRules chop leaveRulesSource
				Validator.validateLeaveRules leaveRulesSpec, stdObjectsSpec, stdSetsSpec

			it 'validates a correct leave rules spec', ->
				expect(-> validate '''
					LEAVERULES
					stone -> dirt
					A -> stone
					ENTERRULES
				''').not.toThrow()


		describe 'ENTERRULES', ->
			stdObjectsSpec = Parser.parseObjects chop '''
					OBJECTS

					stone
					aa
					ab

					dirt
					aa
					ac

					sand
					aa
					ad

					SETS
				'''

			stdSetsSpec = Parser.parseSets chop '''
					SETS
					A = stone dirt
					NEARRULES
				'''

			stdLevelsSpec = Parser.parseLevels chop '''
					LEVELS

					level1
					aaabb
					bbaaa
				'''

			validate = (enterRulesSource) ->
				enterRulesSpec = Parser.parseEnterRules chop enterRulesSource
				Validator.validateEnterRules enterRulesSpec, stdObjectsSpec, stdSetsSpec, stdLevelsSpec

			it 'validates a correct enter rules spec', ->
				expect(-> validate '''
					ENTERRULES
					stone -> stone ; teleport level1 3 1
					A -> stone ; heal 10
					A -> _terrain
					USERULES
				''').not.toThrow()

			it 'throws an error if teleport points to an inexistent level', ->
				expect(-> validate '''
					ENTERRULES
					stone -> dirt ; teleport level2 3 1
					USERULES
				''').toThrowWithMessage 'Level level2 does not exist'

			it 'throws an error if teleportation coordinates are not numbers', ->
				expect(-> validate '''
					ENTERRULES
					stone -> dirt ; teleport level1 a1 3
					USERULES
				''').toThrowWithMessage 'X teleport coordinate must be a number'

			it 'throws an error if teleportation coordinates lie outside the bound of the level', ->
				expect(-> validate '''
					ENTERRULES
					stone -> dirt ; teleport level1 1 3
					USERULES
				''').toThrowWithMessage 'Teleport coordinates must be within level bounds'


		describe 'USERULES', ->
			stdObjectsSpec = Parser.parseObjects chop '''
					OBJECTS

					stone
					aa
					ab

					dirt
					aa
					ac

					sand
					aa
					ad

					SETS
				'''

			stdSetsSpec = Parser.parseSets chop '''
					SETS
					A = stone dirt
					NEARRULES
				'''

			stdSoundsSpec = Parser.parseSounds chop '''
					SOUNDS
					001234 boing
					015678 squiggle

					NEARRULES
				'''

			stdLevelsSpec = Parser.parseLevels chop '''
					LEVELS

					level1
					aaabb
					bbaaa
				'''

			validate = (useRulesSource) ->
				useRulesSpec = Parser.parseUseRules chop useRulesSource
				Validator.validateUseRules useRulesSpec, stdObjectsSpec, stdSetsSpec, stdSoundsSpec, stdLevelsSpec

			it 'validates a correct use rules spec', ->
				expect(-> validate '''
					USERULES
					stone sand -> sand ; teleport level1 3 1
					A sand -> _inventory ; heal 10 ; sound squiggle
					stone A -> _terrain
					LEGEND
				''').not.toThrow()

			it 'throws an error if the terrain item was not defined', ->
				expect(-> validate '''
					USERULES
					marble sand -> sand
					LEGEND
				''').toThrowWithMessage 'Object marble was not defined'

			it 'throws an error if the terrain item was not defined', ->
				expect(-> validate '''
					USERULES
					sand marble -> sand
					LEGEND
				''').toThrowWithMessage 'Object marble was not defined'

			it 'throws an error if the terrain set was not defined', ->
				expect(-> validate '''
					USERULES
					B sand -> sand
					LEGEND
				''').toThrowWithMessage 'Set B was not defined'

			it 'throws an error if the terrain set was not defined', ->
				expect(-> validate '''
					USERULES
					sand B -> sand
					LEGEND
				''').toThrowWithMessage 'Set B was not defined'

			it 'throws an error if the sound was not defined', ->
				expect(-> validate '''
					USERULES
					stone sand -> sand ; sound hiss
					LEGEND
				''').toThrowWithMessage 'Sound hiss was not defined'


		describe 'LEGEND', ->
			stdObjectSpec = Parser.parseObjects chop '''
					OBJECTS

					stone
					aa
					ab

					dirt
					aa
					ac

					sand
					aa
					ad

					SETS
				'''

			validate = (legendSource) ->
				legendSpec = Parser.parseLegend chop legendSource
				Validator.validateLegend legendSpec, stdObjectSpec

			it 'validates a correct legend spec', ->
				expect(-> validate '''
					LEGEND
					s stone
					d dirt

					LEVELS
				''').not.toThrow()

			it 'throws an error if the same binding is used twice', ->
				expect(-> validate '''
					LEGEND
					s stone
					d dirt
					s sand

					LEVELS
				''').toThrow()

			it 'throws an error if the same object is bound to more than one chars', ->
				expect(-> validate '''
					LEGEND
					s stone
					d dirt
					a stone

					LEVELS
				''').toThrow()

			it 'throws an error if bindings are too long', ->
				expect(-> validate '''
					LEGEND
					st stone
					d dirt

					LEVELS
				''').toThrow()

			it 'throws an error if the bound object is undefined', ->
				expect(-> validate '''
					LEGEND
					m marble
					d dirt

					LEVELS
				''').toThrow()

		describe 'LEVELS', ->
			stdLegendSpec = Parser.parseLegend chop '''
					LEGEND

					s stone
					d dirt
					m marble

					LEVELS
				'''

			validate = (levelsSource) ->
				levelsSpec = Parser.parseLevels chop levelsSource
				Validator.validateLevels levelsSpec, stdLegendSpec

			it 'validates a correct levels spec', ->
				expect(-> validate '''
					LEVELS

					first
					sd
					dd

					second
					sdmm
					ddmm
					ddmm
				''').not.toThrow()

			it 'throws an error when redefining a level', ->
				expect(-> validate '''
					LEVELS

					first
					sd
					dd

					second
					sd
					dd

					first
					sd
					dd
				''').toThrowWithMessage 'Level already declared'

			it 'throws an error when defining a non-rectangular level', ->
				expect(-> validate '''
					LEVELS

					first
					sd
					d
				''').toThrowWithMessage 'All level lines must have the same length'

			it 'throws an error when using unbound chars', ->
				expect(-> validate '''
					LEVELS

					first
					sd
					dz
				''').toThrowWithMessage 'No terrain unit is bound to character "z"'