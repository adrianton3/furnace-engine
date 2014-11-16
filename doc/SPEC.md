The furnace language
====================

The specification for a game is a big chunk of text that describes the content of the game (sprites and maps), as well as the rules that make up the gameplay. The specification is divided into the sections listed below:

+ PARAMS
+ COLORS
+ PLAYER
+ OBJECTS
+ SETS
+ SOUNDS (optional)
+ NEARRULES (optional)
+ LEAVERULES (optional)
+ ENTERRULES (optional)
+ USERULES
+ LEGEND
+ LEVELS

Each section deals with a particular aspect of the game and will be described in detail in the remainder of this document. Not all sections are mandatory, but their order is fixed, as in the list above.

Spaces are usually used as separators between tokens. In some cases, however, a new line is required instead.
Single line comments start with `//`
Multi-line comments start with `/*` and end with `*/`

### PARAM
This section contains a list of general parameters (one on each line).
All parameters must be mentioned and their order is not important. The example below illustrates all the supported parameters.

Example:

    PARAM

    camera 11 9                // the size of the camera measured in tiles
    scale 8                    // the scale used when painting pixels
    start_location 11 11 entry // the starting location (x, y and level name)
    inventory_size_max 5       // the maximum size of the inventory
                               // should not be bigger than the width of the camera
    health_max 0               // the number of hit points your character has
                               // leave 0 if the game should not contain the notion of hit points

### COLORS
The section contains the list of color bindings used in defining the player sprites and object tiles.
Colors can be specified either using the `rgb <r> <g> <b>` form or the `rgba <r> <g> <b> <a>` form. The *red*, *green* and *blue* components can take values in the [0..255] range while *alpha* can take values in the [0..1] range.

Example:

    COLORS

    1 rgb 10 20 30     // a rather dark color
    r rgb 120 0 0      // dark red
    R rgb 255 0 0      // bright red
    * rgba 0 0 0 0     // transparent; use only for player sprites
    B rgba 0 0 255 0.5 // semitransparent blue


### PLAYER
A list of player sprites is placed here.
The only necessary sprites are those for: *up*, *down*, *left*, *right* and *health*. Order is not important.
Player sprite size can range between 3 and 16 and must be square. Size needs not be specified anywhere, as the parser will detect it automatically. However, all sprites must be of the same size.

Example:

    PLAYER

    up
    .bbb.
    bbbbb
    bbbbb
    bbbbb
    .bbb.

    down
    .bbb.
    bWbWb
    bbNbb
    bBBBb
    .bbb.

    left
    .bbb.
    Wbbbb
    Nbbbb
    BBbbb
    .bbb.

    right
    .bbb.
    bbbbW
    bbbbN
    bbbBB
    .bbb.

    health
    .r.r.
    rrrrr
    rrrrr
    .rrr.
    ..r..

### OBJECTS
This section contains a list of object tiles. They must be of the same size as player sprites.
In addition, when defining an object it can be specified whether it is blocking or not. Objects can also be animated, as illustrated in the example below:

    OBJECTS

    grass          // a nice patch of simple, plain grass
    ggggg
    ggggg
    ggggg
    ggggg
    ggggg

    stone blocking // you can't pass through stone
    gsssg
    sssss
    sssss
    sssss
    gsssg

    flower
    ggggg
    ggrgg
    gryrg
    ggrGg
    gggGg

    flower:1       // the second frame of the flower
    gggrg
    ggryr
    gggrg
    gggGg
    gggGg

### SETS
This section contains set definitions. Sets can be defined either by enumeration or by composing previously defined sets. Set names must start with a capital letter. The purpose of sets is highlighted in the following sections.

Example:

    SETS

    Grass = grass short-grass tall-grass // typically one groups similar objects in a set
    Weapon = sword dagger
    Furniture = table chair
    Pickable = Weapon or Furniture       // 'or' in this case is an operator
                                         // the other 2 operators are 'and' and 'minus'

### SOUNDS (optional)
This section contains sound bindings. Sounds can be referenced by their binding in the USERULES section.

Example:

    SOUNDS
    032EBF53A930 boingo
    026782C1 blip

### NEARRULES (optional)

Defines what should happen when the player gets *near* tiles
Rules, in general, have on the left-hand side an object name. If this object is part of the terrain and near the player, then the rule applies and the terrain unit transforms in whatever lies on the right-hand side. Certain side effects may also take effect when the rule is applied, such as gaining or losing HP or items.
In this case, near-rules can only have one of two side-effects - *heal* or *hurt*.

Example:

    NEARRULES

    dark-ground -> lit-ground               // this is how unexplored tiles become explored
    fiery-inferno -> fiery-inferno ; hurt 1 // don't stand near fiery infernos!
    life-fountain -> life-fountain ; heal 1 // life fountains are good for your health

### LEAVERULES (optional)

Defines what should happen when the player *leaves* a tile.
Leave-rules can not have side-effects.

Example:

    LEAVERULES

    almost-broken-bridge -> broken-bridge // can't use the bridge anymore
    grass -> slimey-grass                 // snails leave slime behind

### ENTERRULES (optional)

Defines what should happen when the player *enters* a tile.
Possible side-effects are: *give*, *heal*, *hurt*, *teleport*, *message* and *checkpoint*.

Example:

    ENTERRULES

    apple-on-grass -> grass ; give 1 apple          // you just picked up an apple
    health-pack -> floor ; heal 1                   // you picked up a some health
    trap-door -> trap-door ; teleport dungeon 10 20
    welcome-note -> welcome-note ; message "hello!"
    between-levels -> between-levels ; checkpoint   // might want to provide a checkpoint here and there

### USERULES

Defines what should happen when the player *uses* a inventory item on the tile it's facing.
Use-rules have on the left-hand side both what the player has actively selected in the inventory and the terrain object which is in front of the player. In order to reduce the number of rules that need to be written for every possible scenario, sets of individual items may be used instead (see the later rules in the example below). Possible side-effects are: *give*, *consume*, *heal*, *hurt*, *teleport* and *message*.

Example:

    USERULES

    axe tree -> grass ; give 10 wood ; consume // using an axe on a tre will remove the tree and give wood
    coal furnace -> furnace-lit ; consume      // using coal on a furnace will turn on the furnace
    key Doors -> floor ; consume               // use a key on any element in the 'Doors' set
    Pickables Grass -> _inventory ; consume    // placing any pickable item on any grass tile
    hand Pickables -> grass ; give 1 _terrain  // getting back the placed item
    axe Monsters -> grass ; sound growl        // monsters become noisy when attacked

### LEGEND

This section contains a list of bindings for terrain objects. It will be later used in defining levels. It is similar in format to the COLORS section.

Example:

    LEGEND

    g grass
    s sand
    w water

### LEVELS

This section holds the levels of the game. They may be of any size larger than the camera. They need not be square or of the same size.

Example:

    LEVELS

    island
    wwwwwwwwwwwwww
    wwsswsssssssww
    wwssggwggggssw
    wwsssgggggsssw
    wwsssgggssssww
    wwwwwwwwwwwwww

    // a patch of grass surrounded by sand and water