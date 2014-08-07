class EventsController < ApplicationController
  VNDA_API = 'https://bodystore.vnda.com.br'

  def send_event
    order = JSON.parse(request.body.read)

    conn = Excon.new(VNDA_API)
    shipping = JSON.parse(conn.get(path: "/api/v2/orders/#{order['code']}/shipping_address").body)
    billing  = JSON.parse(conn.get(path: "/api/v2/orders/#{order['code']}/billing_address").body)

    render json: SiftClient.new(order, shipping, billing).create_order_event
  end
end
