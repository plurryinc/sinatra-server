class ApplicationController < Sinatra::Base
  set :server, 'thin'
  set :views, File.expand_path('../views', __FILE__)
  set :sass => '../public/assets/css/sass'
  enable :sessions
  set :logging, :true

  configure do
    set :public_folder, 'public'
  end

  private

  def user_signed_in?
    !session[:user_id].nil?
  end

  def current_user
    User.find(session[:user_id])
  end

  def authenticate!
    unless user_signed_in?
      redirect '/users/sign_in'
    end
  end
end
