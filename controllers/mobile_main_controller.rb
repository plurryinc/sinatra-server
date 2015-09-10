class MobileMainController < ApplicationController
  before do
    unless m_user_signed_in?
      unless params[:secret_token].nil?
        authenticate_token! params[:secret_token]
      else
        result = JSON.parse({ result: "fail", what: "authenticate_token" }.to_json)
        halt 401, {'Content-Type' => 'text/plain'}, result
      end
    end
  end
end
