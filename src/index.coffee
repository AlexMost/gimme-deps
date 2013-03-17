detective = require 'detective'
path = require 'path'
fs = require 'fs'
async = require 'async'
{is_dir, resolve_npm_mod_folder, flatten, partial, is_local_require} = require './utils'

# TODO: dela with resolving global objects such as path, fs e.t.c

process_local_require = (module, path, callee, cb) ->  
	cb undefined, {module, callee, path}


process_module_require = (_path, resolved_requires, callee, cb) ->
	resolve_npm_mod_folder callee, (path.dirname _path), (err, dirname) ->
		console.log _path, dirname, callee
		get_from_module dirname, resolved_requires, cb


unique_reducer = (a, b) -> 
	has_item = a.filter((i) -> i.path is b.path).length > 0
	if has_item
		a
	else a.concat b


get_from_file = (file_path, resolved_requires, module, get_deps_cb) ->

	require_processor =  (callee, cb) ->
		is_local_require callee, (path.dirname file_path), (err, is_local) ->
			if is_local is true
				process_local_require(
					module
					path.normalize (path.join (path.dirname file_path), callee) + ".js"
					callee
					cb)
			else
				process_module_require(
					path.join (path.dirname file_path), callee
					resolved_requires
					callee 
					cb)

	rec_func = (m, cb) ->
		get_from_file m.path, resolved_requires, module, cb

	fs.readFile file_path, (err, data) ->
		get_deps_cb("Failed to read file #{file_path}, #{err}", null) if err

		data = data.toString()

		requires = (detective data).filter((a) -> 
			resolved_requires.filter((r) -> r.path is path.join(file_path, a)).length is 0)

		if requires.length
			async.map requires, require_processor, (err, result) ->

				result = flatten(result).filter((a) -> 
					resolved_requires.filter((r) -> r.path is a.path).length is 0)

				resolved_requires = flatten(resolved_requires.concat result)

				async.map result, rec_func, (err, result) ->
					get_deps_cb err, flatten(result).reduce unique_reducer, []
		else
			get_deps_cb err, flatten(resolved_requires)


get_from_module = (_path, resolved, gimme_cb) ->
	npm_module_path = path.resolve _path
	package_json_path = path.join _path, "package.json"
	
	fs.readFile package_json_path, (err, package_json) ->
		package_json = JSON.parse package_json.toString()

		module = package_json.name

		unless package_json.main
			return gimme_cb "Failded to retrive deps from #{module}. Missing main section in package_json"
		
		main_file = path.join _path, package_json.main

		if (path.extname main_file) is ''
			main_file = "#{main_file}.js"
		resolved = resolved.concat [{module, path: main_file, callee: module}]
		get_from_file main_file, resolved, module, (err, data) ->
			gimme_cb err, flatten(data)


gimme_deps = (_path, gimme_cb) ->
	is_dir _path, (err, isdir) ->
		if isdir is true
			get_from_module _path, [], gimme_cb
		else
			get_from_file _path, [], "", gimme_cb


module.exports = gimme_deps