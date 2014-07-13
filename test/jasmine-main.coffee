require.config
  baseUrl: '../src/js'
  paths:
    test: '../../test'

require ['test/lib/jasmine-2.0.0/boot'], ->

  # Load the specs
  require ['test/all-tests'], ->

    # Initialize the HTML Reporter and execute the environment (setup by `boot.js`)
    window.onload()