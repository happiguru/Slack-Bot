# Twitter API connect
require 'Twitter' #gem install twitter
def twitter_connect
    config = {
        consumer_key: '',
        consumer_secret: '',
        access_token: '',
        access_token_secret: ''
    }
    rClient = Twitter::REST::Client.new config
    sClient = Twitter::Streaming::Client.new(config)
end