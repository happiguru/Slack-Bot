# Eyebot Slack class
require 'slack-ruby-bot'
require 'httparty'

class EyeBot < SlackRubbyBot::Bot

    BASE_URl = 'https://www.reddit.com'
    SUBREDDIT_BASE_URL = BASE_URL+'/r/'
    DEFAULT_LIMIT = 10
    # catching explicit command

    command 'list' do |client, data, _match|

    end