require 'sinatra/base'
require 'sinatra-websocket'
require 'sinatra/activerecord'

ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')
Dir.glob('./{models,helpers,controllers}/*.rb').each { |file| require file }

require './app'

run PlurryServer
