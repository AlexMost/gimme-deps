{spawn} = require 'child_process'


build = (callback) ->
    coffee = spawn 'coffee', ['-c', '-o', 'lib-js', 'src']

    coffee.stderr.on 'data', (data) ->
        process.stderr.write data.toString()

    coffee.stdout.on 'data', (data) ->
        print data.toString()

    coffee.on 'exit', (code) ->
        console.log "gimme-deps build is done"
        callback?() if code is 0


task 'build', 'Build lib-js/ from src/', -> build()

