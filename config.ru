require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sass/plugin/rack'
require './app'

Dir.glob('./{models,helpers,controllers}/*.rb').each { |file| require file }
ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')

Sass::Plugin.options[:style] = :compressed
Sass::Plugin.options[:template_location] = './assets/stylesheets'
use Sass::Plugin::Rack

map('/ws') { run WebsocketController }
map('/dashboard') { run DashboardController }
map('/mobile/users') { run MobileAuthenticationController }
map('/mobile') { run MobileMainController }
map('/users') { run AuthenticationController }
map('/') { run HomeController }
