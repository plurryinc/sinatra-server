require 'sinatra/base'
require 'sinatra/activerecord'

Dir.glob('./{models,helpers,controllers}/*.rb').each { |file| require file }
ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')

map('/ws') { run WebsocketController }
map('/users') { run AuthenticationController }
map('/') { run HomeController }
