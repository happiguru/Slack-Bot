require_relative 'lib/auth.rb'
require_relative 'bin/bot.rb'

run Rack::Cascade.new [API, Auth]