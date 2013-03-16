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

info is the flat list of resolved files with their metadata:

``` coffee
# pseudo data structure (coffeescript)
[
	{                                     
		module: "module name",
		module_path: "module path"
		package_json: "package json path"
		callee: "parsed require call"
		path: "filepath"
	},

	# ... other files
]

```

And thats it, no wrapping, no bundling only required modules and their metadata.