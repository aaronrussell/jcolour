{exec} = require 'child_process'

task 'compile', 'Compile JavaScript from the source code', ->
  exec 'coffee -c -o build/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'minify', 'Minify the compiled JavaScript using Google Closure', ->
  exec 'java -jar "./lib/Closure/compiler.jar" --js build/jColour.js --js_output_file build/jColour.min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'docs', 'Compile project documentation', ->
  exec 'docco src/*.coffee', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr