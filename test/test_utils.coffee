path = require 'path'
{is_dir, resolve_npm_mod_folder, unique_red, is_local_require} = require '../src/utils'
fixtures_path = path.resolve './test/fixtures/'


exports.test_resolve_npm_mod_folder = (test) ->
	dirname = path.join fixtures_path, 'modules_imports_test/npm_mod'
	resolve_npm_mod_folder 'async', dirname, (err, result) ->
		expected = path.join fixtures_path, "modules_imports_test/npm_mod/node_modules/async"
		test.ok expected is result, "Wrong resolved npm mod folder expected - #{expected}, recieved - #{result}"
		test.done()


# exports.test_is_local_import = (test) ->
# 	dirname = path.join fixtures_path, 'utils_test'
# 	callee = "local_require"
# 	is_local_require callee, dirname, (err, result) ->
# 		test.ok result is true, "Failed to recognize local require"
# 		test.done()

