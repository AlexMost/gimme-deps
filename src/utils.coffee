resolve = require 'resolve'
fs = require 'fs'
path = require 'path'


is_dir = (fn, cb) ->
    fs.lstat fn, (err, stat) ->
        if err
            cb err, false
        else
            cb err, stat.isDirectory()

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


unique_red = (a, b) -> if b in a then a else a.concat b

module.exports = {is_dir, resolve_npm_mod_folder, unique_red}
