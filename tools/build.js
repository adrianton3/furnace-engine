var requirejs = require('requirejs');
var fs = require('fs');
var colors = require('colors');

function wrap(fileName, head, tail) {
    fs.readFile(fileName, function (err, data) {
        if (err) { throw err; }
        var wrapped = head + data + tail;

        fs.writeFile(fileName, wrapped, function (err) {
            if (err) { throw err; }
            console.log('Done wrapping'.green, fileName);
        });
    });
}

function getHeadWrapping() {
    return [
        '(function () {',
        '  if (localStorage.furnaceDev) { require.config({ baseUrl: "js" }); }',
        '  else (function () {'
    ].join('\n');
}

function getTailWrapping() {
    return [
        '  })();',
        '})();'
    ].join('\n');
}

var outBaseDir = 'out';

var outFile = outBaseDir + '/furnace.js';

var optimizerConfig = {
    optimize: 'none',
    baseUrl: 'src/js',
    name: 'main',
    out: outFile,
    paths: {
        'underscore': 'empty:'
    }
};

requirejs.optimize(optimizerConfig, function (buildResponse) {
    console.log('Done optimizing'.green);

    wrap(outFile, getHeadWrapping(), getTailWrapping());
}, function(err) {
    console.error(err);
});