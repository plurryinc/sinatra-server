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

  get '/:name/new' do
    @group = Group.where(name: params[:name]).take
    erb :'dashboard/new', { :layout => :'layouts/dashboard' }
  end

  post '/:name' do
    group = Group.where(name: params[:name]).take
    group.update_product(params[:products])
    redirect "/dashboard"
  end
end
