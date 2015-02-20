# Description:
#   A way to interact with the JetBrains YouTrack API.
#
# Commands:
#   hubot show issue <query> -

module.exports = (robot) ->
  robot.respond /show issue (.*)/i, (msg) ->
    issueMe msg, msg.match[1], (url) ->
      msg.send url

# Get information about issue
issueMe = (msg, query, cb) ->
  msg.http("https://youtrack.jetbrains.com/rest/issue/#{query}")
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      json = JSON.parse(body)

      return cb(json.value) if json.value

      issue = json.field.reduce (result, field) ->
        result[field.name] = field.value
        return result
      , {}

      console.log issue
      cb renderIssue issue

renderIssue = (issue) ->
  """
    Created by: #{issue.reporterFullName}  Updated by: #{issue.updaterFullName}  (votes: #{issue.votes})


    #{issue.projectShortName}-#{issue.numberInProject}  #{issue.summary}

    Type: #{issue.Type.join(',')}
    --------------------------------------------------------------------------
    State: #{issue.State.join(',')}
    --------------------------------------------------------------------------
    Subsystem: #{issue.Subsystem.join(',')}
    --------------------------------------------------------------------------
    Assignee: #{(issue.Assignee.map (user)-> user.fullName).join(',')}
    --------------------------------------------------------------------------
    Fix versions: #{issue['Fix versions'].join(',')}
    --------------------------------------------------------------------------
    Browser: #{issue.Browser.join(',')}
    --------------------------------------------------------------------------
    OS: #{issue.OS.join(',')}
    --------------------------------------------------------------------------
    Severity: #{issue.Severity.join(',')}
    --------------------------------------------------------------------------
  """
