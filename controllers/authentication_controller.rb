class AuthenticationController < ApplicationController
  get '/sign_up' do
    erb :sign_up
  end

  post '/' do
    User.sign_up params
  end

  get '/sign_in' do
    erb :sign_in
  end

  post '/logout' do
  end
end
