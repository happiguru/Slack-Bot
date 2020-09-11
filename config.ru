require_relative 'lib/auth.rb'
require_relative 'bin/main_bot.rb'

run Rack::Cascade.new [API, Auth]
