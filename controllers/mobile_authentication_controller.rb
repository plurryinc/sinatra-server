class MobileAuthenticationController < ApplicationController
  post '/sign_in' do
    email = params[:email]
    password = params[:password]

    warn(params)

    user = User.where(email: email).take

    if !user.nil? and user.encrypted_password == BCrypt::Engine.hash_secret(params[:password], user.salt)
      unless user.mobile_secret_token.nil?
        session[:mobile_secret_token] = user.mobile_secret_token
        return JSON.parse({ result: "success", what: "sign_in", cache_token: user.mobile_secret_token }.to_json)
      else
        secret_token = Digest::SHA1.hexdigest Time.now.to_f.to_s
        user.update(mobile_secret_token: secret_token)
        return JSON.parse({ result: "success", what: "sign_in", cache_token: secret_token }.to_json)
      end
    else
        return { result: "fail", what: "sign_in" }
    end
  end

  post '/sign_up' do
    warn(params)
    sign_up = User.sign_up params
    return { result: sign_up[:result], what: "sign_up" }
  end

  post '/sign_out' do
    unless session[:mobile_secret_token].nil?
      m_current_user.update(mobile_secret_token: nil)
      session[:mobile_secret_token] = nil
      return JSON.parse({ result: "success", what: "logout" }.to_json)
    else
      return JSON.parse({ result: "fail", what: "logout" }.to_json)
    end
  end
end
