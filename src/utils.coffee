resolve = require 'resolve'
fs = require 'fs'
path = require 'path'
async = require 'async'

local_pattern = /^\.\.?(\/|$)/

partial = (fn) ->
        partial_args = Array::slice.call arguments
        partial_args.shift()
        ->
            [new_args, arg] = [[], 0]
            for a, i in partial_args
                new_args.push(
                    unless partial_args[i] then arguments[arg++] else partial_args[i])
            fn.apply this, new_args


flatten = (array, results = []) ->
    for item in array
        if Array.isArray(item)
            flatten(item, results)
        else
            results.push(item)

    results


is_dir = (fn, cb) ->
    fs.lstat fn, (err, stat) ->
        if err
            cb err, false
        else
            cb err, stat.isDirectory()


is_local_require = (callee, _path, is_local_cb) ->

	_is_match_local = (callee, cb) -> cb null, local_pattern.test callee

	_exists_local = (callee, cb) ->
		fs.exists (path.join _path, "./#{callee}.js"), (exists) ->
			cb null, exists

	async.parallel(
		[
			partial(_is_match_local, callee, undefined)
			#partial(_exists_local, callee, undefined)
		]

		(err, results) ->
			result = results.reduce (a, b) -> a or b
			is_local_cb err, result

		)


resolve_npm_mod_folder = (callee, dirname, cb) ->

	after_val_reducer = (val) ->
		(a, b) ->
			if val in a or b is val
	        	a.concat b
	    	else
	        	a

	resolve callee, {basedir: dirname}, (err, result) ->
		# TODO handle error
		rel_module_dir = result.split('node_modules')[-1..][0]
		rel_module_dir_name = ((rel_module_dir.split path.sep).filter (i) -> i isnt '')[0]

		module_dir = result.split(path.sep)
						   .reverse()
						   .reduce((after_val_reducer rel_module_dir_name), [])
						   .reverse()
						   .join(path.sep)

		cb err, module_dir


module.exports = {is_dir, resolve_npm_mod_folder, flatten, partial, is_local_require}
