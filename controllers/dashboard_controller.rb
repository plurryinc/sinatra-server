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
end
