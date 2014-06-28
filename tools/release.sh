#!/bin/sh
node tools/build.js
mkdir -p tmp
cp out/furnace.js tmp/furnace.js
cp src/js/sampleSpec_1.js tmp/sampleSpec_1.js
cp src/js/sampleSpec_2.js tmp/sampleSpec_2.js
rm out/furnace.js

git checkout gh-pages

cp tmp/furnace.js out/furnace.js
cp tmp/sampleSpec_1.js src/js/sampleSpec_1.js
cp tmp/sampleSpec_2.js src/js/sampleSpec_2.js
rm -rf tmp

git checkout master -- src/index.html
git checkout master -- src/conv.html
git checkout master -- src/parser.html

git checkout master -- src/style/style.css

git checkout master -- src/js/Util.js
git checkout master -- src/js/main.js
git checkout master -- src/js/conv.js

git status