class MobileMainController < ApplicationController
  before do
    content_type :json
    unless params[:secret_token].nil? && User.where(mobile_secret_token: params[:secret_token]).empty?
      authenticate_token! params[:secret_token]
    else
      result = { result: "fail", what: "authenticate_token" }.to_json
      halt 401, {'Content-Type' => 'text/plain'}, result
    end
  end

  post '/groups' do
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

  post '/:group/products' do
    group = m_current_user.groups.where(name: params[:group]).take
    return { result: "fail", what: "products" }.to_json if group.nil?
    products = group.products
    products_list = []
    products.each do |p|
      products_list.push({
        product_id: p.product_id,
        product_secret_token: p.secret_token,
        product_type: p.product_type,
        schedule: p.schedule
      })
    end
    return {
      result: "success",
      what: "products",
      data: products_list
    }.to_json
  end
end
