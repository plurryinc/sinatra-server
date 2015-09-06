class DashboardController < ApplicationController
  before do
    authenticate!
  end

  get '' do
    @groups = current_user.groups
    erb :'dashboard/index', { :layout => :'layouts/dashboard' }
  end

  get '/control/:name' do
    @group = Group.where(name: params[:name]).take
    products = @group.products
    @type1 = products.where(product_type: 1).take
    @type2 = products.where(product_type: 2).take
    @type3 = products.where(product_type: 3).take
    erb :'dashboard/control', { :layout => :'layouts/dashboard' }
  end

  get '/station' do
    erb :'dashboard/station'
  end

  get '/schedule/:name' do
    @group = Group.where(name: params[:name]).take
    erb :'dashboard/schedule', { :layout => :'layouts/dashboard' }
  end

  get '/registration' do
    erb :'dashboard/registration', { :layout => :'layouts/dashboard' }
  end

  post '/registration' do
    redirect "/dashboard/registration" if params[:group].nil? && params[:products].empty?
    result = Group.create_group(current_user.id, params)
    if result
      redirect "/dashboard"
    else
      redirect "/dashboard/registration"
    end
  end

  get '/:name/edit' do
    @group = Group.where(name: params[:name]).take
    products = @group.products
    @type1 = products.where(product_type: 1).take
    @type2 = products.where(product_type: 2).take
    @type3 = products.where(product_type: 3).take
    erb :'dashboard/edit', { :layout => :'layouts/dashboard' }
  end

  get '/remove/:code' do
    product = Product.where(code: params[:code]).take
    product.update(group_id: nil)
    redirect request.env['HTTP_REFERER']
  end

  post '/:name' do
    group = Group.where(name: params[:name]).take
    group.update(name: params[:group]) unless params[:group].strip == ""
    group.update_product(params[:products]) unless params[:products].empty?
    redirect "/dashboard"
  end
end
