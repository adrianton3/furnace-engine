#!/usr/bin/env bash

./node_modules/coffeescript/bin/coffee -c src/js/**/*.coffee

node tools/make-bundle.js