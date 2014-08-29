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

### 0.5.0
 + added validation for NEAR/LEAVE/ENTER/USE RULES

### 0.4.3
 + added validation for SETS and LEVELS

### 0.4.2
 + added validation for COLORS, PLAYER, OBJECTS and LEGEND
 + better error reporting
 + fixed parsing related bugs

### 0.4.1
 + can access both sample games
 + can export/import a game specification to/from a png image
 + can import a game specification from an external text file

### 0.4.0
 + added health via `hurt <quantity>` or `heal <quantity>`
 + can now reset progress by hitting `K`

### 0.3.8
 + checkpoints! use `U` to return to a previous saved state
 + inventory has fixed size
 + fixed inventory bugs when inventory is empty
 + no more mandatory *intial-pickaxe* item

### 0.3.7
 + added support for the alpha channel via `rgba <r> <g> <b> <a>`
 + sprite sheet importer can output in *PuzzleScript* format too

### 0.3.6
 + improved sprite sheet importer
 + extended font
 + added ability to print messages on *enter* and *use* rules

### 0.3.5
 + added sprite sheet importer

### 0.3.4
 + bigger, better, more complex sample game

### 0.3.3
 + added *near* rules
 + *near*, *leave* and *enter* rules are now optional

### 0.3.2
 + can now set starting location
 + editor is hidden by default

### 0.3.1
 + can now configure camera size
 + can now set the scale
 + fixed inventory text rendering

### 0.3.0
 + added *leave* rules
 + added *enter* rules
 + changed *RULES* to *USERULES*

### 0.2.3
 + added a camera

### 0.2.2
 + added animations

### 0.2.1
 + live editor
 + now uses CodeMirror

### 0.2.0
 + added bindings in rules

### v0.1.0
 + basic gameplay in place