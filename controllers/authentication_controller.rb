class AuthenticationController < ApplicationController
  SIGNIN_CALLBACK_PATH = "/dashboard"

  get '/sign_up' do
    redirect "/" if session[:user_id]
    erb :sign_up
  end

  post '' do
    sign_up = User.sign_up params
    if sign_up[:result] == "success"
      session[:user_id] = sign_up[:data].id
      redirect SIGNIN_CALLBACK_PATH
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
    user = User.where(email: email).take

    if !user.nil? and user.encrypted_password == BCrypt::Engine.hash_secret(params[:password], user.salt)
      session[:user_id] = user.id
      redirect SIGNIN_CALLBACK_PATH
    end

    redirect "/users/sign_in"
  end

  get '/sign_out' do
    session[:user_id] = nil unless session[:user_id].nil?
    redirect "/"
  end
end
