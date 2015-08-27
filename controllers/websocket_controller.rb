require 'sinatra-websocket'

class WebsocketController < ApplicationController
  set :sockets, []
  set :rooms, {}

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
