http    = require 'http'
express = require 'express'
Mincer  = require 'mincer'

#Mincer
Mincer.CoffeeEngine.setOptions bare:false
Mincer.logger.use console

mincerEnv = new Mincer.Environment
mincerEnv.appendPath 'src'
mincerEnv.appendPath 'output'
mincerEnv.appendPath 'tests/src'
mincerEnv.appendPath 'tests/assets'

app = express()
server = http.createServer app

app.configure ()->
  app.use express.static "tests/public"
  app.use '/assets', Mincer.createServer(mincerEnv)

server.listen 3300