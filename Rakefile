require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './app'

Dir.glob('./{models,helpers,controllers}/*.rb').each { |file| require file }

namespace :db do
  task :load_config do
  end
end
