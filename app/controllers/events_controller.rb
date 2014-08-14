class EventsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    Rails.logger.error("Shop not found for token: #{params[:token].inspect}")
    head :unauthorized
  end

  def transaction
    order = JSON.parse(request.body.read)

    conn = Excon.new("http://#{shop.vnda_api_host}/", user: shop.vnda_api_user, password: shop.vnda_api_password)
    shipping = JSON.parse(conn.get(path: "/api/v2/orders/#{order['code']}/shipping_address").body)
    billing  = JSON.parse(conn.get(path: "/api/v2/orders/#{order['code']}/billing_address").body)

    SiftClient.new(shop.sift_api_key).transaction(order, shipping, billing)

    head :ok
  end

  private

  def shop
    @shop ||= Shop.find_by!(token: params[:token])
  end
end
