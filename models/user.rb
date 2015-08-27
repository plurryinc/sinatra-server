require 'bcrypt'

class User < ActiveRecord::Base
  has_many :groups

  def self.sign_up params
    email = params[:email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    return { result: "fail", data: "이미 존재하는 이메일입니다." } if User.where(email: email).take

    #패스워드, 패스워드 확인이 같을 경우
    if password === password_confirmation
      password_salt = BCrypt::Engine.generate_salt
      password_hash = BCrypt::Engine.hash_secret(password, password_salt)

      user = User.create(email: email, encrypted_password: password_hash, salt: password_salt)
      return { result: "success", data: user }
    else
      return { result: "fail", data: "패스워드가 다릅니다." }
    end
  end
end
