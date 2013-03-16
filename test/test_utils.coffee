path = require 'path'
{is_dir, resolve_npm_mod_folder, unique_red} = require '../src/utils'
fixtures_path = path.resolve './test/fixtures/'

exports.test_resolve_npm_mod_folder = (test) ->
	dirname = path.join fixtures_path, 'modules_imports_test/npm_mod'
	resolve_npm_mod_folder 'async', dirname, (err, result) ->
		test.done()

