require 'sinatra/base'
require 'slack-ruby-client'

class SlackBot
  def self.welcome_text
    'Welcome to Slack Bot Team! Glad to have you! Please complete the steps below'
  end

  def self.slack_json
    instruct_file = File.read('../initialize.json')
    instruct_json = JSON.parse(instruct_file)
    instruct_json['attachments']
    # attachments = instruct_json['attachments']
  end

  def self.items
    { reaction: 0, pin: 1, share: 2 }
  end

  def self.new
    instruct_json.deep_dup
  end
end
