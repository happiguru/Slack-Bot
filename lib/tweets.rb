
def tweetsearch
    topics_to_watch = ['#rails', '#ruby', 'Ruby on Rails', 'Microverse']
    sClient.filter(:track => topics_to_watch.join(',')) do |tweet|
        if tweet.is_a?(Twitter::Tweet)
            puts tweet.text
            rClient.fav tweet
        end
    end
rescue
    puts 'error occured, waiting for 5 seconds'
    sleep 5
end
