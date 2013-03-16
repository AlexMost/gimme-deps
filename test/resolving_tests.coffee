path = require 'path'
gdeps = require '../src/'
fixtures_path = path.resolve './test/fixtures/'


exports.test_resolve_from_module = (test) ->
	etalon_filenames = ["preprocessor.js", "recursive_test.js", "compiler.js"]
	gdeps (path.join fixtures_path, "local_imports_test/npm_mod"), (err, info) ->
		test.ok info.length is 3, "Expected 3 parsed deps, recieved - #{info.length}"
		info.map (m) -> 
			fn = (path.basename m.path)
			test.ok fn in etalon_filenames, "Not all files were parsed from npm module #{fn}"
		test.done()

