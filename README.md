gimme-deps
==========

If you want to know what files are required from node module or just simple file, their absolute file pahts, their package names and another metadata from package.json`s
just make:

``` sh
npm install gimme-deps
```

``` coffeescript
info = gimme-deps 'path to some file or module'
```

info is the flat list of packages that were used in module sources :

``` coffee
# pseudo data structure (coffeescript)

packages:
[
	"module_name":{                                     
		"packagejson":                                      
		files:[                                             #  module files
			"./file_name": "/file/path/absolute/filename"   #  <require statement> : file absolute path

			# ... other files
			]
	},

	# ... other packages
]

files: [                                             #  module files
		"./file_name": "/file/path/absolute/filename"   #  <require statement> : file absolute path

		# ... other files
]

```

And thats it, no wrapping, no bundling only required modules and their metadata.