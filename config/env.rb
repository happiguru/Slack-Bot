#OAuth Access Token

SLACK_API_TOKEN = 'xoxb-1341131635942-1371806137072-mMv2rmaKF60hzHylmFoN76wj'

    Slack.configure do |config|
    config.Token = ENV['SLACK_API_TOKEN']
    end
