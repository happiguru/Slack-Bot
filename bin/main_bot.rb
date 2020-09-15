require 'slack-ruby-client'
require_relative '../lib/api.rb'
require_relative '../lib/events.rb'

class SlackBot
  # attr_accessor :team_id
  # attr_accessor :user_id
  # attr_accessor :index_item

  # def initialize
  #   @team_id = team_id
  #   @user_id = user_id
  #   @index_item = index_item
  # end

  def self.welcome_text
    'Welcome to Slack Bot Team! Glad to have you! Please complete the steps below'
  end

  def self.update_item(team_id, user_id, index_item)
    slackbot_item = @teams[team_id][user_id][:slackbot_content][index_item]
    slackbot_item['text'].sub!(':white_large_square:', ':white_check_mark:')
    slackbot_item['color'] = '#F47FF1'
  end

  def self.slackbot_json
    slackbot_file = File.read('../initialize.json')
    slackbot_json = JSON.parse(slackbot_file)
    slackbot_json['attachments']
    # attachments = slackbot_json['attachments']
  end

  def self.items
    { reaction: 0, pin: 1, share: 2 }
  end

  def self.new
    slackbot_json.deep_dup
  end
end
