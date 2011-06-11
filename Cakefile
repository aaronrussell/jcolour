{exec} = require 'child_process'

task 'compile', 'Compile JavaScript from the source code', ->
  exec 'coffee -c -o ./ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'minify', 'Minify the compiled JavaScript using Google Closure', ->
  exec 'java -jar "/Users/aaron/Java/compiler.jar" --js ./jColour.js --js_output_file ./jColour.min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
