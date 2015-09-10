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

phrases = [
  'Remembers me of ',
  'I can only think about ',
  'For sure this is ',
  'I would guess ',
]

Clarifai = require('./clarifai-nodejs/clarifai_node.js')
Clarifai.setVerbose( false )
tHandler = (bThrottled, waitSeconds) ->
  console.log if bThrottled then "throttled. service available again in #{waitSeconds} seconds" else "not throttled"
Clarifai.setThrottleHandler tHandler

module.exports = (robot) ->
  robot.respond /what is this (.*)/i, (msg) ->
      Clarifai.initAPI(process.env.CLIENT_ID, process.env.CLIENT_SECRET)
      query = msg.match[1]
      console.log Clarifai._clientId
      commonResultHandler = ( err, res ) ->
        if err isnt null
            if err['status_code']? is 'string'
              console.log 'got an error'
              msg.send "lolwut?"
        else
          console.log 'no error!!!'
          console.log res['status_code']
          beginWith = msg.random phrases
          msg.send beginWith + res['results'][0].result['tag']['classes'].join(', ')

      Clarifai.tagURL query , 'hubot-query', commonResultHandler
      Clarifai.clearThrottleHandler()
