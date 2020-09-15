require 'slack-ruby-client'
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

  def self.update_i(team_id, user_id, index_item)
    bot_item = team[team_id][user_id][:bot_content][index_item]
    bot_item['text'].sub!(':white_large_square:', ':white_check_mark:')
    bot_item['color'] = '#F47FF1'
  end

  def self.welcome_text
    'Welcome to Slack Bot Team! Glad to have you! Please complete the steps below'
  end

  def self.slack_json
    instruct_file = File.read('../initialize.json')
    slack_json = JSON.parse(instruct_file)
    slack_json['attachments']
    # attachments = slack_json['attachments']
  end

  def self.items
    { reaction: 0, pin: 1, share: 2 }
  end

  def self.new
    slack_json
  end
end

