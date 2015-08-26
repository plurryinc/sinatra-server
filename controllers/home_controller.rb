class HomeController < ApplicationController
  get '/' do
    erb :index, { :layout => :'layouts/main' }
  end
end
