require 'rubygems'
require 'bundler/setup'

require 'dotenv'
require 'sinatra'
require 'json'
require 'faraday'

Dotenv.load

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

post '/paddle-custom-checkout' do
  amount = params['amount']
  conn = Faraday.new(url: 'https://vendors.paddle.com/api/2.0')
  post_data = {
    vendor_id: ENV['PADDLE_VENDOR_ID'],
    vendor_auth_code: ENV['PADDLE_VENDOR_AUTH_CODE'],
    title: 'Product with custom pricing',
    prices: ["USD:#{amount}"],
    webhook_url: 'https://rw-p3.herokuapp.com/paddle',
    quantity_variable: 0
  }
  response = conn.post('product/generate_pay_link', post_data)
  decoded = JSON.parse(response.body)
  return decoded['response']['url'] if decoded['success']
  status 500
  body 'Unable to generate URL'
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
