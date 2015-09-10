# Description:
#   Recognizes image in URL using Clarifai's API
#
# Dependencies:
#   None
#
# Configuration:
#   1 - Register an app at developers.clarifai.com
#   2 - Export enviroment variables using the IDs from the previous step:
#       * CLIENT_ID
#       * CLIENT_SECRET
#
# Commands:
#   recognize me [URL] - Tags image
#
# Author:
#   edersantana

Clarifai = require('./clarifai-nodejs/clarifai_node.js')

module.exports = (robot) ->
  robot.respond /dafuq is (.*)/i, (msg) ->
      Clarifai.initAPI(process.env.CLIENT_ID, process.env.CLIENT_SECRET)
      query = msg.match[1]
      commonResultHandler = ( err, res ) ->
          if res["status_code"]? == "OK"
              # the request completed successfully
              tags = res["results"][i].result["tag"]["classes"]
              # tags.replace("," , ", ")
              msg.send 'let me think...'
              msg.send tags

      Clarifai.tagURL query , 'hubot-query', commonResultHandler
