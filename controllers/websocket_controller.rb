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
            begin
              if is_valid_cmd? msg
                unless settings.rooms[hash].nil?
                  settings.sockets.each do |s|
                    if settings.rooms[hash].include? (s.object_id)
                      s.send msg
                    end
                  end
                end
              else
                product = Product.where(product_id: hash).take
                if is_valid_json? msg
                  Log.create_log(product.id, msg)
                end
                if msg.eql? "healthCheck"
                  Log.create(
                    product_id: product.id,
                    message_type: "phone health check",
                    create_time: Time.now.to_i
                  )
                end
                unless settings.rooms["debug_" + hash].nil?
                  settings.sockets.each do |s|
                    if settings.rooms["debug_" + hash].include? (s.object_id)
                      s.send msg
                    end
                  end
                end
              end
=begin
              settings.sockets.each do |s|
                if settings.rooms[hash].include? (s.object_id)
                  s_index = settings.rooms[hash].index(s.object_id)
                  if is_valid_cmd? msg
                    s.send msg
                  else
                    unless settings.rooms["debug_" + hash].nil?
                      settings.sockets.each do |s|
                        if settings.rooms["debug_" + hash].include? (s.object_id)
                          s.send(msg)
                        end
                        if s.object_id == settings.rooms["debug_" + hash][s_index]
                          if is_valid_json? msg
                            product = Product.where(product_id: hash).take
                            Log.create_log(product.id, msg)
                          end
                          s.send(msg)
                        end
                      end
                    end
                  end
                end
              end
=end
            rescue Exception => e
              puts "fail because...=> #{e.message}"
            end
          end
        end
        ws.onclose do
          warn("websocket closed")
          settings.rooms[hash].delete(ws.object_id)
          settings.sockets.delete(ws)
        end
      end
    end
  end

  get '/:hash/:product' do |hash, product|
    if !request.websocket?
      erb :ws
    else
      request.websocket do |ws|
        ws.onopen do
          ws.send("Debug! Channel : #{product}")
          settings.sockets << ws
          settings.rooms["debug_" + product] = Array.new if settings.rooms["debug_" + product].class != Array
          settings.rooms["debug_" + product] << ws.object_id
          ws.send("object_id : " + ws.object_id.to_s)
          session[:debug_ws_id] = ws.object_id
        end

        ws.onmessage do |msg|
          EM.next_tick do
            begin
              settings.sockets.each do |s|
                if settings.rooms["debug_" + product].include? (s.object_id)
                  s.send("remote on") if msg.eql? "web-open"
                  s.send(msg) if !msg.eql? "web-open"
                end
              end
            rescue Exception => e
              puts "fail because...=> #{e.message}"
            end
          end
        end

        ws.onclose do
          warn("websocket closed")
          settings.rooms["debug_" + product].delete(ws.object_id)
          settings.sockets.delete(ws)
        end
      end
    end
  end

  private

  def is_valid_cmd? string
    begin
      json = JSON.parse string
      return !json["cmd"].nil?
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
