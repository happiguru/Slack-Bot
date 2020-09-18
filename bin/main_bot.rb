require 'json'
require_relative '../lib/api.rb'
require_relative '../lib/events.rb'

class SlackBot
  attr_accessor :team_id
  attr_accessor :user_id
  attr_accessor :index_item

  def initialize
    @team_id = team_id
    @user_id = user_id
    @index_item = index_item
  end

  def welcome_text
    'Welcome to Slack Bot Team! Glad to have you! Please complete the steps below'
  end

  def update_item(team_id, user_id, index_item)
    slackbot_item = @teams[team_id][user_id][:slackbot_content][index_item]
    slackbot_item['text'].sub!(':white_large_square:', ':white_check_mark:')
    slackbot_item['color'] = '#F47FF1'
  end

  def slackbot_json
    slackbot_file = File.read('initialized.json')
    slackbot_json = JSON.parse(slackbot_file)
    slackbot_json['attachments']
  end

  def items
    { reaction: 0, pin: 1, share: 2 }
  end

  def news
    slackbot_json.dup
  end
end
