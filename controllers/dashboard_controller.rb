class DashboardController < ApplicationController
  set :sockets, []
  set :rooms, {}

  before do
    redirect "/" if session[:user_id].nil?
    @user = User.find(session[:user_id])
  end

  get '' do
    erb :dashboard, { :layout => :'layouts/dashboard' }
  end

  get '/:hash' do |hash|
    if !request.websocket?
      erb :ws
    else
      request.websocket do |ws|
        ws.onopen do
          ws.send("Hello World! Channel : #{hash}")
          settings.sockets << ws
          settings.rooms[hash] = Array.new if settings.rooms[hash].class != Array
          settings.rooms[hash] << ws.object_id
          logger.info "======="
          logger.info settings.inspect
          logger.info settings.sockets.first.methods
          logger.info settings.sockets.last.object_id
          ws.send("object_id : " + ws.object_id.to_s)
          session[:ws_id] = ws.object_id
        end
        ws.onmessage do |msg|
          EM.next_tick do
            settings.sockets.each do |s|
              if settings.rooms[hash].include? (s.object_id)
                s.send(msg)
              end
            end
          end
        end
        ws.onclose do
          warn("websocket closed")
          settings.sockets.delete(ws)
        end
      end
    end
  end
end
