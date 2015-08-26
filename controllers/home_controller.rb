class HomeController < ApplicationController
  get '/' do
    erb :index, { :layout => :'layouts/main' }
  end

  get '/dashboard' do
    erb :dashboard, { :layout => :'layouts/dashboard' }
  end
end
