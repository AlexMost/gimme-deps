gimme-deps
==========

If you want to know what files are required from node module or just simple file, their absolute file pahts, their package names and another metadata from package.json`s
just make:

``` sh
npm install gimme-deps
```

## Usage

``` coffeescript
gimme-deps 'path to some file or module', (err, info) ->
	# processing info data

```


And thats it, no wrapping, no bundling only required modules and their metadata.
You can process them as you want - bundle, wrapp, analize e.t.c.

## **info** structure
- **info.files** - flat structure of all files that were resolved from module and from it's dependencies.

```
info.files = [
	# file 
	{
	  path: <path to module file (relative to current path)>
	  callee: <how this file was required from the module sources>
	},
	...
]
```

- **info.module** - returns module name
- **info.main_file** - absolute path to module main file
- **info.module_path** - absolute path to module folder
- **info.package_json** - module package.json object
