furnace-engine
==============

A PuzzleScript like engine

**Try it:**

* [Sample game: Little furnace](http://madflame991.github.io/furnace-engine/src/index.html?sample=little-furnace)
* [Sample game: Under the snow](http://madflame991.github.io/furnace-engine/src/index.html?sample=under-the-snow)
* [Sprite importer (Furnace/PuzzleScript formats)](http://madflame991.github.io/furnace-engine/src/conv.html)
* [Furnace format doc](https://github.com/madflame991/furnace-engine/tree/master/doc/SPEC.md)
* [Detailed parsing demo](http://madflame991.github.io/furnace-engine/src/parser.html)

Changelog
---------

#### r21
 + added the SOUNDS section and sounds for USERULES
 + added 5 types of procedurally generated sounds

#### r20
 + separated the editor in its own window
 + small styling tweaks
 + using release count as version tracking

#### r19
 + added validation for NEAR/LEAVE/ENTER/USE RULES

#### r18
 + added validation for SETS and LEVELS

#### r17
 + added validation for COLORS, PLAYER, OBJECTS and LEGEND
 + better error reporting
 + fixed parsing related bugs

#### r16
 + can access both sample games
 + can export/import a game specification to/from a png image
 + can import a game specification from an external text file

#### r15
 + added health via `hurt <quantity>` or `heal <quantity>`
 + can now reset progress by hitting `K`

#### r14
 + checkpoints! use `U` to return to a previous saved state
 + inventory has fixed size
 + fixed inventory bugs when inventory is empty
 + no more mandatory *intial-pickaxe* item

#### r13
 + added support for the alpha channel via `rgba <r> <g> <b> <a>`
 + sprite sheet importer can output in *PuzzleScript* format too

#### r12
 + improved sprite sheet importer
 + extended font
 + added ability to print messages on *enter* and *use* rules

#### r11
 + added sprite sheet importer

#### r10
 + bigger, better, more complex sample game

#### r9
 + added *near* rules
 + *near*, *leave* and *enter* rules are now optional

#### r8
 + can now set starting location
 + editor is hidden by default

#### r7
 + can now configure camera size
 + can now set the scale
 + fixed inventory text rendering

#### r6
 + added *leave* rules
 + added *enter* rules
 + changed *RULES* to *USERULES*

#### r5
 + added a camera

#### r4
 + added animations

#### r3
 + live editor
 + now uses CodeMirror

#### r2
 + added bindings in rules

#### r1
 + basic gameplay in place