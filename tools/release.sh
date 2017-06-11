#!/bin/sh
./build.sh
mkdir -p tmp
cp out/furnace.js tmp/furnace.js
cp src/js/sampleSpec_1.js tmp/sampleSpec_1.js
cp src/js/sampleSpec_2.js tmp/sampleSpec_2.js
cp src/js/Util.js tmp/Util.js
cp src/js/parser.js tmp/parser.js
rm out/furnace.js

git checkout gh-pages

cp tmp/furnace.js out/furnace.js
cp tmp/sampleSpec_1.js src/js/sampleSpec_1.js
cp tmp/sampleSpec_2.js src/js/sampleSpec_2.js
cp tmp/Util.js src/js/Util.js
cp tmp/parser.js src/js/parser.js
rm -rf tmp

git checkout master -- src/index.html
git checkout master -- src/editor.html
git checkout master -- src/conv.html
git checkout master -- src/parser.html

git checkout master -- src/style

git checkout master -- src/js/conv.js

git add -u

git status