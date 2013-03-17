path = require 'path'
gdeps = require '../src/'
fixtures_path = path.resolve './test/fixtures/'


exports.test_resolve_from_module = (test) ->
	etalon_filenames = ["preprocessor.js", "recursive_test.js", "compiler.js", "recursive2.js"]
	gdeps (path.join fixtures_path, "local_imports_test/npm_mod"), (err, info) ->
		test.ok info.length is 4, "Expected 4 parsed deps, recieved - #{info.length}"
		console.log info
		info.map (m) -> 
			fn = (path.basename m.path)
			test.ok fn in etalon_filenames, "Not all files were parsed from npm module #{fn}"
		test.done()


exports.test_resolve_from_module = (test) ->
	# etalon_filenames = ["preprocessor.js", "recursive_test.js", "compiler.js", "recursive2.js"]
	gdeps (path.join fixtures_path, "modules_imports_test/npm_mod"), (err, info) ->
		#test.ok info.length is 4, "Expected 4 parsed deps, recieved - #{info.length}"
		console.log info
		#info.map (m) -> 
		#	fn = (path.basename m.path)
		#	test.ok fn in etalon_filenames, "Not all files were parsed from npm module #{fn}"
		test.done()
