gimme-deps
==========

If you want to know what files are required from npm package or some file, their absolute file pahts, their package names and another metadata from package.json`s
just make:

``` sh
npm install gimme-deps
```

``` coffeescript
info = gimme-deps 'path to some file or module'
```

info is the flat list of packages that were used in module sources :

``` coffee
packages:
[
	"package1":{                                  #  --- pacakge name
	"packagejson":                                #  --- package.json file
	"main":                                       #  --- absolute main filepath
	files:[                                       #  --- list of files that are resolved from require functions of package source files.
		"./file_name": "absolute file path"

		# ...
		]
	},

	# ...
]
```

And thats it, no wrapping, no bundling only required modules and their metadata.