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
        code: p.code,
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
  
  post '/new' do
    if params[:group].nil? && params[:products].empty?
      return {
        result: "fail",
        what: "registration"
      }.to_json
    end
    result = Group.create_group(m_current_user.id, params)
    if result
      return {
        result: "success",
        what: "registration"
      }.to_json
    else
      return {
        result: "fail",
        what: "registration"
      }.to_json
    end
  end

  post '/:name/update' do
    group = Group.where(name: params[:name]).take
    group.update(name: params[:group]) unless params[:group].strip == ""
    group.m_update_product(params[:products]) unless params[:products].empty?
    return { result: "success", what: "product update" }.to_json
  end

  post '/:product/schedule' do
    product = Product.where(product_id: params[:product]).take
    return { result: "success", what: "product schedule", data: product.schedule }.to_json
  end

  post '/:product/schedule/update' do
    product = Product.where(product_id: params[:product]).take
    schedules = product.schedule
    schedules.each_with_index do |schedule, index|
      if(schedules[index]["id"] == params[:nid].to_i)
        if(params[:time] == "empty")
          schedules[index]["status"] = true
        else 
          schedules[index]["status"] = false
        end
        schedules[index]["time"] = params[:time]
        schedules[index]["amount"] = params[:amount].to_i
        break
      end
    end
    product.update(schedule: schedules)
    return { result: "success", what: "schedule update" }.to_json
  end

end
