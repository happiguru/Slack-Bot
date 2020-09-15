# Eyebot Slack class
require 'sinatra/base'
require 'slack-ruby-bot'
require 'slack-ruby-client'
require_relative '../.env.rb'

SLACK_CONFIG = {
  slack_client_id: SLACK_CLIENT_ID,
  slack_api_secret: SLACK_API_SECRET,
  slack_redirect_uri: SLACK_REDIRECT_URI,
  slack_verification_token: SLACK_VERIFICATION_TOKEN
}.freeze

# Check to see if required variables were provided
missing_params = SLACK_CONFIG.select { |_key, value| value.nil? }
if missing_params.any?
  error_message = missing_params.keys.join(', ').upcase
  raise "Missing Slack config variables: #{error_message}"
end

# Set OAuth Scope for the Slack-Bot
BOT_SCOPE = 'bot'.freeze

# Initialize a hash variable to hold team information
@teams = {}

# Helper to keep all logic together
def create_slack_cleint(slack_api_secret)
  Slack.configure do |config|
    config.token = slack_api_secret
    raise 'Missing API token' unless config.token
  end
  Slack::Web::Client.new
end

class Auth < Sinatra::Base
  add_to_slack_button = %(
      <a href=\"https://slack.com/oauth/authorize?scope=#{BOT_SCOPE}&client_id=#{SLACK_CONFIG[:slack_client_id]}
      &redirect_uri=#{SLACK_CONFIG[:redirect_uri]}\">
      <img alt="Add to Slack" height="40" width="139" src="https://platform.slack-edge.com/img/add_to_slack.png"/></a>
    )

  get '/events' do
    redirect '/begin_auth'
  end

  get '/begin_auth' do
    status 200
    body add_to_slack_button
  end

  get '/finish_auth' do
    client = Slack::Web::Client.new
    begin
      response = client.oauth_access(
        {
          client_id: SLACK_CONFIG[:slack_client_id],
          client_secret: SLACK_CONFIG[:slack_api_secret],
          redirect_uri: SLACK_CONFIG[:slack_redirect_uri],
          code: params[:code]
        }
      )

      team_id = response['team_id']
      @teams[team_id] = {
        user_access_token: response['access_token'],
        bot_user_id: response['bot']['bot_user_id'],
        bot_access_token: response['bot']['bot_access_token']
      }

      @teams[team_id]['client'] = create_slack_cleint(response['bot']['bot_access_token'])

      status 200
      body 'Gloraay! Authentication succeeded!'
    rescue Slack::Web::Api::Error => e
      status 403
      body "Oooops! Authentication failed! Reason: #{e.message}<br/>#{add_to_slack_button}"
    end
  end
end
