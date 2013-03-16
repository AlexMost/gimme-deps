detective = require 'detective'
path = require 'path'
fs = require 'fs'


CALL_EXPRESSION = "CallExpression"
relative_pattern = /^\.\.?(\/|$)/


unique_red = (a, b) -> if b in a then a else a.concat b

# TODO: return in format {mod_name, filepath, ns}
get_file_require_deps = (file_path, ns, resolved_requires, get_deps_cb) ->
	fs.readFile file_path, (err, data) -> 
		requires = (detective data).map (req) -> 
			# TODO: check if relative or npm module require
			"#{(path.join (path.dirname file_path), req)}.js"

		if requires.length
			resolved_requires = (resolved_requires.concat requires).reduce unique_red, []

			reducer = (a, b) ->  
				get_file_require_deps b, a, (err, data) ->
					if data?
						get_deps_cb err, data

			requires.reduce reducer, resolved_requires

		else
			get_deps_cb err, resolved_requires


get_npm_module_deps = (npm_module_path) ->
	npm_module_path = path.resolve npm_module_path
	package_json_path = path.join npm_module_path, "package.json"
	ns = package_json.name
	main_file = path.join npm_module_path, package_json.main
	#TODO read_ns from package_json
	fs.readFile package_json_path, (err, package_json) ->
		get_file_require_deps main_file, ns, [], (err, data) ->
			console.log '---', data


module.exports = {get_npm_module_deps}

