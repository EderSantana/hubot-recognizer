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
Clarifai.setVerbose( false )
tHandler = (bThrottled, waitSeconds) ->
  console.log if bThrottled then "throttled. service available again in #{waitSeconds} seconds" else "not throttled"
Clarifai.setThrottleHandler tHandler

module.exports = (robot) ->
  robot.respond /dafuq is (.*)/i, (msg) ->
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
          console.log msg
          msg.send res['results'][0].result['tag']['classes'].join(', ')
        if typeof res['status_code']? is 'string' and (res["status_code"] == "OK" or res["status_code"] == "PARTIAL_ERROR")
          for i in [0..res.results.length-1]
            if res["results"][i]["status_code"] == "OK"
              console.log ('docid='+res.results[i].docid +
                ' local_id='+res.results[i].local_id +
                ' tags='+res["results"][i].result["tag"]["classes"])
              msg.send res['results'][i].result['tag']['classes'].join(', ')
            else
              console.log ('docid='+res.results[i].docid +
                ' local_id='+res.results[i].local_id +
                ' status_code='+res.results[i].status_code +
                ' error = '+res.results[i]["result"]["error"])

      Clarifai.tagURL query , 'hubot-query', commonResultHandler
      Clarifai.clearThrottleHandler()
