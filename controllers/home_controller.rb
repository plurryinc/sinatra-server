class HomeController < ApplicationController
  get '/' do
    erb :index, { :layout => :'layouts/main' }
  end

  get '/dashboard' do
    redirect "/" if session[:user_id].nil?
    @user = User.find(session[:user_id])
    erb :dashboard, { :layout => :'layouts/dashboard' }
  end
end
