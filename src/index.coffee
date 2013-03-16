detective = require 'detective'
path = require 'path'
fs = require 'fs'
{is_dir, resolve_npm_mod_folder, unique_red} = require './utils'

relative_pattern = /^\.\.?(\/|$)/


# TODO: return in format {mod_name, filepath, module}
get_from_file = (file_path, resolved_requires, module, get_deps_cb) ->
	fs.readFile file_path, (err, data) ->
		data = data.toString()
		requires = (detective data).map (callee) ->
			# TODO: check if relative or npm module require
			if relative_pattern.test
				{module, callee, path:"#{(path.join (path.dirname file_path), callee)}.js"}
			#else
			#	resolve_npm_mod_folder callee, (path.dirname filepath), (err, dirname) ->
			#		#get_from_module dirname, resolved_requires, get_deps_cb

		if requires.length
			resolved_requires = (resolved_requires.concat requires).reduce unique_red, []

			reducer = (a, b) ->  
				get_from_file b.path, a, module, (err, data) ->
					if data?
						get_deps_cb err, data

			requires.reduce reducer, resolved_requires

		else
			get_deps_cb err, resolved_requires


get_from_module = (_path, resolved, gimme_cb) ->
	npm_module_path = path.resolve _path
	package_json_path = path.join _path, "package.json"
	
	fs.readFile package_json_path, (err, package_json) ->
		package_json = JSON.parse package_json.toString()
		module = package_json.name
		main_file = path.join _path, package_json.main
		get_from_file main_file, resolved, module, (err, data) ->
			gimme_cb err, data


gimme_deps = (_path, gimme_cb) ->
	is_dir _path, (err, isdir) ->
		if isdir is true
			get_from_module _path, [], gimme_cb
		else
			get_from_file _path, [], "", gimme_cb


module.exports = gimme_deps