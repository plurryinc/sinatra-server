class AuthenticationController < ApplicationController
  get '/sign_up' do
    redirect "/" if session[:user_id]
    erb :sign_up
  end

  post '/' do
    sign_up = User.sign_up params
    if sign_up.result == "success"
      session[:user_id] = sign_up.data.id
    else
    end
    redirect "/"
  end

  get '/sign_in' do
    erb :sign_in
  end

  post '/logout' do
  end
end
