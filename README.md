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

info is the flat list of resolved files and modules :

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