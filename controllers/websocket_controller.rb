require 'sinatra-websocket'
require 'json'

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
                if is_valid_json? msg
                  unless msg[:cmd].nil?
                    s.send(msg)
                  else
                    # 서버 내부 처리 rs / report
                  end
                else
                  # 무시 (로깅만)
                end
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

  get '/debug/:hash' do |hash|
    if !request.websocket?
      erb :ws
    else
      request.websocket do |ws|
        ws.onopen do
          ws.send("Debug! Channel : #{hash}")
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
                if is_valid_json? msg
                  unless msg[:cmd].nil?
                    s.send(msg)
                  else
                    # 서버 내부 처리 rs / report
                  end
                else
                  # 무시 (로깅만)
                end
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

  private

  def is_valid_json? string
    begin
      JSON.parse string
      return true
    rescue Exception => e
      return false
    end
  end
end
