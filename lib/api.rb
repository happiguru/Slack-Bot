require 'sinatra/base'

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
  