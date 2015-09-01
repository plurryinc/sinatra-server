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
          ws.send("CMD! Channel : #{hash}")
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
                puts is_valid_cmd? msg
                puts msg
                if is_valid_cmd? msg
                  s.send(msg)
                else
                  unless settings.rooms["debug_" + hash].nil?
                    settings.rooms["debug_" + hash].each do |d|
                      settings.sockets.each do |s|
                        if s.object_id == d
                          s.send msg
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        ws.onclose do
          warn("websocket closed")
          settings.rooms.delete(hash)
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
          settings.rooms["debug_" + hash] = Array.new if settings.rooms["debug_" + hash].class != Array
          settings.rooms["debug_" + hash] << ws.object_id
          ws.send("object_id : " + ws.object_id.to_s)
          session[:debug_ws_id] = ws.object_id
        end
        ws.onmessage do |msg|
          EM.next_tick do
            settings.sockets.each do |s|
              if settings.rooms["debug_" + hash].include? (s.object_id)
                s.send(msg)
              end
            end
          end
        end
        ws.onclose do
          warn("websocket closed")
          settings.rooms.delete("debug_" + hash)
          settings.sockets.delete(ws)
        end
      end
    end
  end

  private

  def is_valid_cmd? string
    begin
      JSON.parse string
      return !string["cmd"].nil?
    rescue Exception => e
      return false
    end
  end

  def is_valid_json? string
    begin
      JSON.parse string
      return true
    rescue Exception => e
      return false
    end
  end
end
