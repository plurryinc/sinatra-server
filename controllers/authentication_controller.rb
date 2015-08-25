class AuthenticationController < ApplicationController
  get '/sign_up' do
    redirect "/" if session[:user_id]
    erb :sign_up
  end

  post '' do
    sign_up = User.sign_up params
    if sign_up[:result] == "success"
      session[:user_id] = sign_up[:data].id
      redirect "/"
    else
      redirect "/users/sign_in"
    end
  end

  get '/sign_in' do
    redirect "/" if session[:user_id]
    erb :sign_in
  end

  post '/sign_in' do
    email = params[:email]
    user = User.where(email: params[:email]).take

    if user.encrypted_password == BCrypt::Engine.hash_secret(params[:password], user.salt)
      session[:user_id] = user.id
      redirect "/"
    end
    redirect "/users/sign_in"
  end

  post '/logout' do
  end
end
