path = require 'path'
gdeps = require '../src/'
fixtures_path = path.resolve './test/fixtures/'


exports.test_resolve_from_module = (test) ->
	etalon_filenames = ["preprocessor.js", "recursive_test.js", "compiler.js", "recursive2.js", "index.js"]
	gdeps (path.join fixtures_path, "local_imports_test/npm_mod"), (err, info) ->

		test.ok(
			info.length is etalon_filenames.length
			"Expected #{etalon_filenames.length} parsed deps, recieved - #{info.length}\n #{JSON.stringify info, null, 4}")

		info.map (m) -> 
			fn = (path.basename m.path)
			test.ok fn in etalon_filenames, "Not all files were parsed from npm module #{fn}"

		test.done()


exports.test_resolve_from_module_with_node_modules_deps = (test) ->
	etalon_filenames = ["preprocessor.js", "recursive_test.js", "compiler.js", "index.js", "async.js", "test.js"]
	gdeps (path.join fixtures_path, "modules_imports_test/npm_mod"), (err, info) ->

		test.ok(
			info.length is etalon_filenames.length
			"Expected #{etalon_filenames.length} parsed deps, recieved - #{info.length}\n #{JSON.stringify info, null, 4}")

		info.map (m) -> 
			fn = (path.basename m.path)
			test.ok fn in etalon_filenames, "Not all files were parsed from npm module #{fn}"

		test.done()


exports.test_resolve_from_node_modules_folder = (test) ->
	gdeps (path.join fixtures_path, "modules_imports_test/node_modules/optimist"), (err, info) ->
		console.log info
		test.done()

