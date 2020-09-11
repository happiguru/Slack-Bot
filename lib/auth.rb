# Eyebot Slack class
require 'sinatra/base'
require 'slack-ruby-bot'
require 'slack-ruby-client'
require_relative '../env.rb'

SLACK_CONFIG = {
    slack_client_id: SLACK_CLIENT_ID,
    slack_api_secret: SLACK_API_SECRET,
    slack_redirect_uri: SLACK_REDIRECT_URI,
    slack_verification_token: SLACK_VERIFICATION_TOKEN
}.freeze

#Check to see if required variables were provided
missing_params = SLACK_CONFIG.select { |_key, value| value.nil? }
if missing_params.any?
    error_message = missing_params.keys.join(', ').upcase
    raise "Missing Slack config variables: #{error_message}"
end

# Set OAuth Scope for the Slack-Bot
BOT_SCOPE = 'bot'.freeze