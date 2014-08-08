class EventsController < ApplicationController
  def transaction
    order = JSON.parse(request.body.read)

    host = ENV['VNDA_API_HOST']
    user = ENV['VNDA_API_USER']
    password = ENV['VNDA_API_PASSWORD']

    conn = Excon.new("https://#{user}:#{password}@#{host}")
    shipping = JSON.parse(conn.get(path: "/api/v2/orders/#{order['code']}/shipping_address").body)
    billing  = JSON.parse(conn.get(path: "/api/v2/orders/#{order['code']}/billing_address").body)

    SiftClient.transaction(order, shipping, billing)

    head :ok
  end

  def bad_user
    SiftClient.bad_user(params[:client_id])

    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to '/', notice: 'Denuncia enviada' }
    end
  end
end
