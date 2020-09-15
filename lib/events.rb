class Events
  def self.user_join(team_id, event_data)
    user_id = event_data['user']['id']

    @teams[team_id][user_id] = {
      slackbot_content: SlackBot.new
    }
    send_response(team_id, user_id)
  end

  def self.reaction_added(team_id, event_data)
    user_id = event_data['user']
    return unless @teams[team_id][user_id]

    channel = event_data['item']['channel']
    time_stamp = event_data['item']['ts']
    SlackBot.update_item(team_id, user_id, SlackBot.items[:reaction])
    send_response(team_id, user_id, channel, time_stamp)
  end

  def self.pin_added(team_id, event_data)
    user_id = event_data['user']
    return unless @teams[team_id][user_id]

    channel = event_data['item']['channel']
    time_stamp = event_data['item']['message']['ts']
    SlackBot.update_item(team_id, user_id, SlackBot.items[:pin])
    send_response(team_id, user_id, channel, time_stamp)
  end

  def self.message(team_id, event_data)
    user_id = event_data['user']
    return if user_id == @teams[team_id][:bot_user_id]

    return unless event_data['attachments'] && event_data['attachments'].first['is_share']

    user_id = event_data['user']
    time_stamp = event_data['attachments'].first['ts']
    channel = event_data['channel']
    SlackBot.update_item(team_id, user_id, SlackBot.items[:share])
    send_response(team_id, user_id, channel, time_stamp)
  end

  def self.send_response(team_id, user_id, channel = user_id, time_stamp = nil)
    if time_stamp
      @teams[team_id]['client'].chat_update(
        as_user: 'true',
        channel: channel,
        time_stamp: ts,
        text: SlackBot.welcome_text,
        attachments: @teams[team_id][user_id][:slackbot_content]
      )
    else
      @teams[team_id]['client'].chat_postMessage(
        as_user: 'true',
        channel: channel,
        text: SlackBot.welcome_text,
        attachments: @teams[team_id][user_id][:slackbot_content]
      )
    end
  end
end
