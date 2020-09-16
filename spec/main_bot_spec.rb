require_relative '../bin/main_bot.rb'

describe SlackBot do
  describe '#welcome_text' do
    it 'returns a welcome message and gives instruction'
    s = SlackBot.new
    expect(s.welcome_text).to eql('Welcome to Slack Bot Team! Glad to have you! Please complete the steps below')
  end
end
