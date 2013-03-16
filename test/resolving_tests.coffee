path = require 'path'
gdeps = require '../src/'
fixtures_path = path.resolve './test/fixtures/'



exports.test_resolve_from_module = (test) ->
	gdeps (path.join fixtures_path, "local_imports_test/npm_mod"), (err, info) ->
		test.ok info.length is 3, "Expected 3 parsed deps, recieved - #{info.length}"
		test.done()

