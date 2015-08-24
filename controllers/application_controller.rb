class ApplicationController < Sinatra::Base
  set :server, 'thin'
  set :views, File.expand_path('../../views', __FILE__)
  enable :sessions
end
