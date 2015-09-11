class MobileMainController < ApplicationController
  before do
    content_type :json
    if(!m_user_signed_in? && params[:secret_token].nil?)
      result = { result: "fail", what: "authenticate_token" }.to_json
      halt 401, {'Content-Type' => 'text/plain'}, result
    else
      unless m_current_user.mobile_secret_token == params[:secret_token]
        result = { result: "fail", what: "authenticate_token" }.to_json
        halt 401, {'Content-Type' => 'text/plain'}, result
      end
    end
  end

  post '/group' do
    groups = m_current_user.groups
    group_list = []
    groups.each do |g|
      group_list.push(g.name)
    end
    return {
      result: "success",
      what: "groups",
      data: group_list
    }.to_json
  end
end
