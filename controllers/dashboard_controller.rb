class DashboardController < ApplicationController
  before do
    authenticate!
  end

  get '' do
    erb :'dashboard/index', { :layout => :'layouts/dashboard' }
  end

  get '/control/:name' do
    erb :'dashboard/control', { :layout => :'layouts/dashboard' }
  end
end
