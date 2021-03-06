require_relative '../bin/main_bot.rb'

describe SlackBot do
  describe '#welcome_text' do
    it 'returns a welcome message and gives instruction' do
      s = SlackBot.new
      expect(s.welcome_text).to eql 'Welcome to Slack Bot Team! Glad to have you! Please complete the steps below'
    end
  end

  describe '#slackbot_json' do
    it 'sends an array containing the message in initialized.json file' do
      s = SlackBot.new
      expect(s.slackbot_json).to be_truthy
    end
  end

  describe '#items' do
    it 'give a list of selections to be updated based on the slack reactions' do
      s = SlackBot.new
      expect(s.items).to be_truthy
    end
  end

  describe '#new' do
    it 'returns a deep copy of the harsh file returned by the slack_json method' do
      s = SlackBot.new
      expect(s.news).to be_truthy
    end
  end
end
