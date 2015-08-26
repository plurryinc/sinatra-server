class ApplicationController < Sinatra::Base
  set :server, 'thin'
  set :views, File.expand_path('../../views', __FILE__)
  set :sass => '../../public/assets/css/sass'
  enable :sessions

  configure do
    set :public_folder, 'public'
  end
end
