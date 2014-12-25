define(function () {
    'use strict';

    ace.define('ace/mode/furnace-rules', function (require, exports, module) {
        var oop = require('../lib/oop');
        var TextHighlightRules = require('./text_highlight_rules').TextHighlightRules;

        var FurnaceHighlightRules = function () {
            var SECTION = 'keyword';
            var BINDING = 'variable';
            var RESERVED = 'constant.other';
            var STRING = 'string';
            var COMMENT = 'comment';
            var SETBINDING = 'storage.type';
            var PLAIN = 'text';

            this.$rules = {
                'start': [{
                    token: SECTION,
                    regex: /^\s*PARAM\s*$/,
                    next: 'PARAM'
                }],
                'PARAM': [{
                    token: SECTION,
                    regex: /^\s*COLORS\s*$/,
                    next: 'COLORS'
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: BINDING,
                    regex: /^[_a-zA-Z]\w*/
                }, {
                    token: PLAIN,
                    regex: /\w+/
                }],
                'COLORS': [{
                    token: SECTION,
                    regex: /^\s*PLAYER\s*$/,
                    next: 'PLAYER'
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: BINDING,
                    regex: /^\w/
                }, {
                    token: RESERVED,
                    regex: /rgb|rgba/
                }, {
                    token: PLAIN,
                    regex: /\d+/
                }],
                'PLAYER': [{
                    token: SECTION,
                    regex: /^\s*OBJECTS\s*$/,
                    next: 'OBJECTS'
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: BINDING,
                    regex: /^\s*\w+\s*$/,
                    next: 'PLAYER-data'
                }, {
                    token: BINDING,
                    regex: /^\s*\w+\s*(?=\/\/)/,
                    next: 'PLAYER-data'
                }],
                'PLAYER-data': [{
                    token: PLAIN,
                    regex: /^\w+$/
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: PLAIN,
                    regex: /^\s*$/,
                    next: 'PLAYER'
                }],
                'OBJECTS': [{
                    token: SECTION,
                    regex: /^\s*SETS\s*$/,
                    next: 'SETS'
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: BINDING,
                    regex: /^\s*\w+(?:\:\d+)?(?=\s+blocking)/
                }, {
                    token: RESERVED,
                    regex: /blocking\s*$/,
                    next: 'OBJECTS-data'
                }, {
                    token: BINDING,
                    regex: /^\s*\w+(?:\:\d+)?\s*$/,
                    next: 'OBJECTS-data'
                }, {
                    token: BINDING,
                    regex: /^\s*\w+(?:\:\d+)?\s*(?=\/\/)/,
                    next: 'OBJECTS-data'
                }],
                'OBJECTS-data': [{
                    token: PLAIN,
                    regex: /^\w+$/
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: PLAIN,
                    regex: /^\s*$/,
                    next: 'OBJECTS'
                }],
                'SETS': [{
                    token: SECTION,
                    regex: /^\s*SOUNDS\s*$/,
                    next: 'SOUNDS'
                }, {
                    token: SECTION,
                    regex: /^\s*NEARRULES\s*$/,
                    next: 'NEARRULES'
                }, {
                    token: SECTION,
                    regex: /^\s*LEAVERULES\s*$/,
                    next: 'LEAVERULES'
                }, {
                    token: SECTION,
                    regex: /^\s*ENTERRULES\s*$/,
                    next: 'ENTERRULES'
                }, {
                    token: SECTION,
                    regex: /^\s*USERULES\s*$/,
                    next: 'USERULES'
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: RESERVED,
                    regex: /=|and|or|minus/
                }, {
                    token: SETBINDING,
                    regex: /[A-Z]\w*/
                }, {
                    token: BINDING,
                    regex: /[a-z]\w*/
                }],
                'SOUNDS': [{
                    token: SECTION,
                    regex: /^\s*NEARRULES\s*$/,
                    next: 'NEARRULES'
                }, {
                    token: SECTION,
                    regex: /^\s*LEAVERULES\s*$/,
                    next: 'LEAVERULES'
                }, {
                    token: SECTION,
                    regex: /^\s*ENTERRULES\s*$/,
                    next: 'ENTERRULES'
                }, {
                    token: SECTION,
                    regex: /^\s*USERULES\s*$/,
                    next: 'USERULES'
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: PLAIN,
                    regex: /^[0-9A-F]+/
                }, {
                    token: BINDING,
                    regex: /\w+/
                }],
                'NEARRULES': [{
                    token: SECTION,
                    regex: /^\s*LEAVERULES\s*$/,
                    next: 'LEAVERULES'
                }, {
                    token: SECTION,
                    regex: /^\s*ENTERRULES\s*$/,
                    next: 'ENTERRULES'
                }, {
                    token: SECTION,
                    regex: /^\s*USERULES\s*$/,
                    next: 'USERULES'
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: RESERVED,
                    regex: /->|;|heal|hurt/
                }, {
                    token: SETBINDING,
                    regex: /[A-Z]\w*/
                }, {
                    token: BINDING,
                    regex: /[a-z]\w*/
                }],
                'LEAVERULES': [{
                    token: SECTION,
                    regex: /^\s*ENTERRULES\s*$/,
                    next: 'ENTERRULES'
                }, {
                    token: SECTION,
                    regex: /^\s*USERULES\s*$/,
                    next: 'USERULES'
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: RESERVED,
                    regex: /->/
                }, {
                    token: SETBINDING,
                    regex: /[A-Z]\w*/
                }, {
                    token: BINDING,
                    regex: /[a-z]\w*/
                }],
                'ENTERRULES': [{
                    token: SECTION,
                    regex: /USERULES/,
                    next: 'USERULES'
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: STRING,
                    regex: /"(?:(?:\\.)|(?:[^"\\]))*"/
                }, {
                    token: RESERVED,
                    regex: /->|;|,|_terrain|_inventory|give|heal|hurt|teleport|message|checkpoint/
                }, {
                    token: SETBINDING,
                    regex: /[A-Z]\w*/
                }, {
                    token: BINDING,
                    regex: /[a-z]\w*/
                }],
                'USERULES': [{
                    token: SECTION,
                    regex: /LEGEND/,
                    next: 'LEGEND'
                }, {
                    token: STRING,
                    regex: /"(?:(?:\\.)|(?:[^"\\]))*"/
                }, {
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: RESERVED,
                    regex: /->|;|,|_terrain|_inventory|give|heal|hurt|teleport|message|sound|consume/
                }, {
                    token: SETBINDING,
                    regex: /[A-Z]\w*/
                }, {
                    token: BINDING,
                    regex: /[a-z]\w*/
                }],
                'LEGEND': [{
                    token: SECTION,
                    regex: /LEVELS/,
                    next: 'LEVELS'
                }, {
                    token: BINDING,
                    regex: /^[\w!@#$%^&*\-=+]/
                }],
                'LEVELS': [{
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: BINDING,
                    regex: /^\s*\w+\s*$/,
                    next: 'LEVELS-data'
                }, {
                    token: BINDING,
                    regex: /^\s*\w+\s*(?=\/\/)/,
                    next: 'LEVELS-data'
                }],
                'LEVELS-data': [{
                    token: COMMENT,
                    regex: /\/\/.*$/
                }, {
                    token: PLAIN,
                    regex: /^\w+$/
                }, {
                    token: PLAIN,
                    regex: /^\s*$/,
                    next: 'LEVELS'
                }]
            };
        };

        oop.inherits(FurnaceHighlightRules, TextHighlightRules);

        exports.FurnaceHighlightRules = FurnaceHighlightRules;
    });
});
