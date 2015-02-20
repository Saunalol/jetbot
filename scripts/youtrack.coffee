# Description:
#   YouTrack integration script for hubot
#

module.exports = (robot) ->
  robot.respond /Y!?/i, (msg) ->
    msg.send "Yo!"
