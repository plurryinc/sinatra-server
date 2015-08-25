require 'bcrypt'

class User < ActiveRecord::Base

  def self.sign_up params
    email = params[:email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    #패스워드, 패스워드 확인이 같을 경우
    if password === password_confirmation
      password_salt = BCrypt::Engine.generate_salt
      password_hash = BCrypt::Engine.hash_secret(password, password_salt)

      user = User.create(email: email, encrypted_password: password_hash, salt: password_salt)

      session[:user_id] = user.id
      redirect "/"
    end
  end
end
