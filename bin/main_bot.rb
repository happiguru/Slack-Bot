require 'sinatra/base'
require 'slack-ruby-client'

class SlackBot
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

  def self.update_i(team_id, user_id, index_item)
    bot_item = team[team_id][user_id][:bot_content][index_item]
    bot_item['text'].sub!(':white_large_square:', ':white_check_mark:')
    bot_item['color'] = '#F47FF1'
  end
end

class API < Sinatra::Base
  post '/events' do
    request_data = JSON.parse(request.body.read)

    unless SLACK_CONFIG[:slack_verification_token] == request_data['token']
      halt 403, "Invalid Slack verification token received: #{request_data['token']}"
    end

    case request_data['type']
    when 'url_verification'
      request_data['challenge']

    when 'event_callback'
      team_id = request_data['team_id']
      event_data = request_data['event']

      case event_data['type']
      when 'team_join'
        Events.user_join(team_id, event_data)

      when 'reaction_added'
        Events.reaction_added(team_id, event_data)

      when 'pin_added'
        Events.pin_added(team_id, event_data)

      when 'message'
        Events.message(team_id, event_data)

      else
        puts "Unexpected event:\n"
        puts JSON.pretty_generate(request_data)
      end
      status 200
    end
  end
end

class Events
  def self.user_join(team_id, event_data)
    user_id = event_data['user']['id']

    teams[team_id][user_id] = {
      bot_content: SlackBot.new
    }
    send_response(team_id, user_id)
  end

  def self.reaction_added(team_id, event_data)
    user_id = event_data['user']
    if teams[team_id][user_id]
      channel = event_data['item']['channel']
      time_stamp = event_data['item']['ts']
      SlackBot.update_i(team_id, user_id, SlackBot.items[:reaction])
      send_response(team_id, user_id, channel, time_stamp)
    end
  end

  def self.pin_added(team_id, event_data)
    user_id = event_data['user']
    if teams[team_id][user_id]
      channel = event_data['item']['channel']
      time_stamp = event_data['item']['message']['ts']
      SlackBot.update_i(team_id, user_id, SlackBot.items[:pin])
      send_response(team_id, user_id, channel, time_stamp)
    end
  end

  def self.message(team_id, event_data)
    user_id = event_data['user']
    unless user_id == teams[team_id][:bot_user_id]

      if event_data['attachments'] && event_data['attachments'].first['is_share']
        user_id = event_data['user']
        time_stamp = event_data['attachments'].first['ts']
        channel = event_data['channel']
        SlackBot.update_i(team_id, user_id, SlackBot.items[:share])
        send_response(team_id, user_id, channel, time_stamp)
      end
    end
  end

  def self.send_response(team_id, user_id, channel = user_id, time_stamp = nil)
    if time_stamp
      teams[team_id]['client'].chat_update(
        as_user: 'true',
        channel: channel,
        time_stamp: time_stamp,
        text: SlackBot.welcome_text,
        attachments: teams[team_id][user_id][:bot_content]
      )
    else
      teams[team_id]['client'].chat_postMessage(
        as_user: 'true',
        channel: channel,
        text: SlackBot.welcome_text,
        attachments: teams[team_id][user_id][:bot_content]
      )
    end
  end
end
