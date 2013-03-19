detective = require 'detective'
path = require 'path'
fs = require 'fs'
async = require 'async'
{is_dir, resolve_npm_mod_folder, flatten, partial, is_local_require, extend} = require './utils'

# TODO: dela with resolving global objects such as path, fs e.t.c

process_local_require = (module, path, callee, main_file, cb) ->  
	cb undefined, {module, callee, path}


process_module_require = (_path, resolved_requires, callee, cb) ->
	resolve_npm_mod_folder callee, (path.dirname _path), (err, dirname) ->
		unless err
			get_from_module dirname, resolved_requires, cb
		else
			#console.log err
			cb()


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
					file_path
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
		return get_deps_cb(null, []) if err?

		data = data.toString()

		requires = (detective data).filter((a) -> 
			resolved_requires.filter((r) -> r.path is path.join(file_path, a)).length is 0)

		if requires.length
			async.map requires, require_processor, (err, result) ->
				result = flatten(result).filter (r) -> r?
				result = result.filter((a) -> resolved_requires.filter(
					(r) -> r.path is a.path).length is 0)

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
		resolved = resolved.concat [
			{module, path: main_file, callee: module, main_file, module_path:_path, package_json}
			]
		get_from_file main_file, resolved, module, (err, data) ->
			gimme_cb err, flatten(data)


gimme_deps = (_path, gimme_cb) ->
	reduce_in_packages = (a, b) ->
		mod_file = {path: b.path, callee: b.callee}

		unless b.module of a
			pack = {files : [mod_file]}
			a[b.module] = extend pack, b
		else
			a[b.module] = extend a[b.module], b
			a[b.module].files.push mod_file

		delete a[b.module].path
		delete a[b.module].callee
		a

	is_dir _path, (err, isdir) ->
		if isdir is true
			get_from_module _path, [], (err, info) ->

				unless err?
					info = info.reduce reduce_in_packages, {}
				res_list = (v for k, v of info)
				gimme_cb err, res_list
		else
			get_from_file _path, [], "", gimme_cb


module.exports = gimme_deps