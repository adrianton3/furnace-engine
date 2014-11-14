define [
  'generator/SpriteSheetGenerator'
  'Util'
  'World'
  'Item'
  'Items'
  'Set'
  'rule/NearRule'
  'rule/LeaveRule'
  'rule/EnterRule'
  'rule/UseRule'
  'rule/RuleSet'
  'Vec2'
  'Level'
  'sound/Sound'
  'sound/SoundUtil'
], (
  SpriteSheetGenerator
  Util
  World
  Item
  Items
  Set
  NearRule
  LeaveRule
  EnterRule
  UseRule
  RuleSet
  Vec2
  Level
  Sound
  SoundUtil
) ->

  Generator = {}

  Generator.generate = (spec) ->
    params = generateParams(spec.params, spec.levels)
    playerSpritesByName = generatePlayer(spec.player, spec.colors, params.scale)
    Items.collection = generateObjects(spec.objects, spec.colors, params.scale)

    setsByName = generateSets(spec.sets)

    nearRuleSet = generateNearRules(spec.nearRules, setsByName)
    leaveRuleSet = generateLeaveRules(spec.leaveRules, setsByName)
    enterRuleSet = generateEnterRules(spec.enterRules, setsByName)
    useRuleSet = generateUseRules(spec.useRules, setsByName)

    # sort of hacky
    tileDimensions = playerSpritesByName.left.end.sub(playerSpritesByName.left.start)
    levelsByName = generateLevels(spec.levels, spec.legend, tileDimensions)

    createWorld = (sounds) ->
      new World(
        playerSpritesByName
        levelsByName
        params.startLocation
        nearRuleSet
        leaveRuleSet
        enterRuleSet
        useRuleSet
        tileDimensions
        params.camera
        params.inventorySizeMax
        params.healthMax
        sounds
      )

    (if spec.sounds
      generateSounds spec.sounds
    else
      Promise.resolve({})
    ).then createWorld



  generateParams = (params, levelsSpec) ->
    # needs rewriting using some variant of deepExend
    paramSpec = Util.arrayToObject params, 'name', 'parts'

    camera:
      x: +paramSpec.camera[0] or 7
      y: +paramSpec.camera[1] or 7

    scale: +paramSpec.scale[0] or 8
    startLocation:
      x: +paramSpec.start_location[0] or 2
      y: +paramSpec.start_location[1] or 2
      levelName: paramSpec.start_location[2] or levelsSpec[0].name

    inventorySizeMax: +paramSpec.inventory_size_max[0] or 5
    healthMax: +paramSpec.health_max[0]

  Generator.generateParams = generateParams


  generatePlayer = (playerSpec, colorSpec, scale) ->
    namedPlayerSprites = SpriteSheetGenerator.generate playerSpec, colorSpec, scale
    Util.arrayToObject namedPlayerSprites, 'name', 'sprite'

  Generator.generatePlayer = generatePlayer


  generateObjects = (objectsSpec, colorSpec, scale) ->
    processSpriteName = (nam) ->
      separator = nam.lastIndexOf ':'
      if separator == -1
        name: nam
        frame: 0
      else
        name: nam.substr(0, separator)
        frame: +nam.substr(separator + 1)

    namedSprites = SpriteSheetGenerator.generate(objectsSpec, colorSpec, scale)

    blockingObjects = {}
    objectsSpec.forEach (objectSpec) ->
      blockingObjects[objectSpec.name] = true if objectSpec.blocking
      return

    groupedSprites = Util.groupBy(namedSprites, (namedSprite) ->
      frameAndName = processSpriteName(namedSprite.name)
      frameAndName.name
    )

    namedSpriteGroups = Util.objectToArray groupedSprites, 'groupName', 'namedSprites'
    itemsByName = {}
    namedSpriteGroups.forEach (namedSpriteGroup) ->
      sortedSprites = namedSpriteGroup.namedSprites.map((namedSprite) ->
        nameAndFrame = processSpriteName(namedSprite.name)

        sprite: namedSprite.sprite
        name: nameAndFrame.name
        frame: nameAndFrame.frame
      ).sort (a, b) -> a.frame - b.frame

      sprites = sortedSprites.map (namedSprite) -> namedSprite.sprite

      itemsByName[namedSpriteGroup.groupName] = new Item(
        namedSpriteGroup.groupName,
        Util.capitalize(namedSpriteGroup.groupName),
        sprites,
        !!blockingObjects[namedSpriteGroup.groupName]
      )
      return

    itemsByName

  Generator.generateObjects = generateObjects


  generateSets = (spec) ->
    operators =
      or: Set::union
      and: Set::intersection
      minus: Set::difference

    setsByName = {}
    spec.forEach (setDefinition) ->
      set = undefined
      if setDefinition.elements
        set = new Set()
        setDefinition.elements.forEach (element) ->
          set.add element
          return
      else
        operand1 = setsByName[setDefinition.operand1]
        operand2 = setsByName[setDefinition.operand2]
        operator = operators[setDefinition.operator]
        set = operator.call(operand1, operand2)

      setsByName[setDefinition.name] = set
      return

    setsByName

  Generator.generateSets = generateSets


  generateNearRules = (rulesSpec, setsByName) ->
    rules = rulesSpec.map (ruleSpec) ->
      inTerrainItemName = ruleSpec.inTerrainItemName
      outTerrainItemName = ruleSpec.outTerrainItemName
      healthDelta = 0
      healthDelta += +ruleSpec.heal if ruleSpec.heal
      healthDelta -= +ruleSpec.hurt if ruleSpec.hurt
      new NearRule(inTerrainItemName, outTerrainItemName, healthDelta)

    new RuleSet(rules, setsByName)

  Generator.generateNearRules = generateNearRules


  generateLeaveRules = (rulesSpec, setsByName) ->
    rules = rulesSpec.map (ruleSpec) ->
      inTerrainItemName = ruleSpec.inTerrainItemName
      outTerrainItemName = ruleSpec.outTerrainItemName
      new LeaveRule(inTerrainItemName, outTerrainItemName)

    new RuleSet(rules, setsByName)

  Generator.generateLeaveRules = generateLeaveRules


  generateEnterRules = (rulesSpec, setsByName) ->
    rules = rulesSpec.map (ruleSpec) ->
      inTerrainItemName = ruleSpec.inTerrainItemName
      outTerrainItemName = ruleSpec.outTerrainItemName

      # some don't give back anything
      outInventoryItems = undefined
      if ruleSpec.give
        outInventoryItems = ruleSpec.give.map((entry) ->
          itemName: entry.itemName
          quantity: +entry.quantity
        )
      else
        outInventoryItems = []

      healthDelta = 0
      healthDelta += +ruleSpec.heal if ruleSpec.heal
      healthDelta -= +ruleSpec.hurt if ruleSpec.hurt
      teleport = undefined
      if ruleSpec.teleport
        teleport =
          x: +ruleSpec.teleport.x
          y: +ruleSpec.teleport.y
          levelName: ruleSpec.teleport.levelName

      message = undefined
      message = ruleSpec.message if ruleSpec.message
      new EnterRule(
        inTerrainItemName,
        outTerrainItemName,
        outInventoryItems,
        healthDelta,
        teleport,
        message,
        ruleSpec.checkpoint
      )

    new RuleSet(rules, setsByName)

  Generator.generateEnterRules = generateEnterRules


  generateUseRules = (rulesSpec, setsByName) ->
    rules = rulesSpec.map (ruleSpec) ->
      inTerrainItemName = ruleSpec.inTerrainItemName
      inInventoryItemName = ruleSpec.inInventoryItemName
      outTerrainItemName = ruleSpec.outTerrainItemName

      # some don't give back anything
      outInventoryItems = undefined
      if ruleSpec.give
        outInventoryItems = ruleSpec.give.map (entry) ->
          itemName: entry.itemName
          quantity: +entry.quantity
      else
        outInventoryItems = []

      consume = !!ruleSpec.consume

      healthDelta = 0
      healthDelta += +ruleSpec.heal if ruleSpec.heal
      healthDelta -= +ruleSpec.hurt if ruleSpec.hurt

      teleport = undefined
      if ruleSpec.teleport
        teleport =
          x: +ruleSpec.teleport.x
          y: +ruleSpec.teleport.y
          levelName: ruleSpec.teleport.levelName

      message = undefined
      message = ruleSpec.message if ruleSpec.message

      sound = ruleSpec.sound

      new UseRule(
        inTerrainItemName
        inInventoryItemName
        outTerrainItemName
        outInventoryItems
        consume
        healthDelta
        teleport
        message
        sound
      )

    new RuleSet(rules, setsByName)

  Generator.generateUseRules = generateUseRules


  generateLevels = (namedStringedLevels, legendSpec, tileDimensions) ->
    levelsByName = {}
    legend = Util.arrayToObject(legendSpec, 'name', 'objectName')
    namedStringedLevels.forEach (namedStringedLevel) ->
      data = namedStringedLevel.data.map (line) ->
        line.split('').map (char) ->
          itemName = legend[char]
          Items.collection[itemName]

      levelDimensions = new Vec2(data[0].length, data.length)
      levelsByName[namedStringedLevel.name] = new Level(
        namedStringedLevel.name,
        data,
        levelDimensions,
        tileDimensions
      )
      return

    levelsByName

  Generator.generateLevels = generateLevels


  generateSounds = (sounds) ->
    soundsById = {}

    promises = sounds.map (entry) ->
      [generation, type] = entry.soundString

      spec = Sound.getSpec generation, type
      parameters = SoundUtil.decode entry.soundString, spec

      Sound.generate generation, type, parameters
      .then (buffer) ->
        soundsById[entry.id] = buffer

    Promise.all promises
    .then ->
      soundsById


  Generator
