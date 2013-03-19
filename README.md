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

info is the flat list of resolved packages with files with their metadata:

```

And thats it, no wrapping, no bundling only required modules and their metadata.
You can process them as you want - bundle, wrapp, analize e.t.c.
