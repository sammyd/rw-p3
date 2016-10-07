require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'

clients = []

get '/' do
  erb :index
end

post '/paddle' do
  data = Rack::Utils.parse_nested_query(request.body.read.to_s)
  p [:paddle, data]
  clients.each { |client| client.send(data.to_json) }
  status 200
  body ''
end

post '/500' do
  data = request.body.read.to_s
  p [:error, data]
  status 500
  body ''
end

get '/ws' do
  if Faye::WebSocket.websocket?(request.env)
    ws = Faye::WebSocket.new(request.env)

    ws.on(:open) do
      p [:open, ws.object_id]
      clients << ws
    end

    ws.on(:close) do |event|
      p [:close, ws.object_id, event.code, event.reason]
      clients.delete(ws)
      ws = nil
    end

    ws.rack_response
  else
    erb '<h1>WebSockets Only</h1>'
  end
end
