class SiftClient
  API_URL = 'https://api.siftscience.com/v203/'

  def initialize(api_key)
    @api_key = api_key
  end

  def transaction(order, shipping_address, billing_address)
    send_request('events',
      '$type' => '$transaction',
      '$user_id' => order['client_id'].to_s,
      '$user_email' => order['email'],
      '$amount' => convert_price(order['total']),
      '$transaction_status' => '$success',
      '$order_id' => order['code'],
      '$currency_code' => 'BRL',
      '$payment_method' => build_payment_method(order),
      '$billing_address'  => build_address(billing_address),
      '$shipping_address' => build_address(shipping_address)
    )
  end

  def bad_user(client_id)
    send_request("users/#{client_id}/labels", '$is_bad' => true)
  end

  private

  def send_request(path, event)
    json = event.merge('$api_key' => @api_key).to_json
    response = Excon.post(API_URL + path, body: json)
    Rails.logger.info('Siftscience API Response: ' + response.body)
  end

  def build_address(a)
    {
      '$name'      => [a['first_name'], a['last_name']].reject(&:blank?).join(' '),
      '$address_1' => [a['street_name'], a['street_number'], a['complement']].reject(&:blank?).join(' '),
      '$address_2' => a['neighborhood'],
      '$city'      => a['city'],
      '$region'    => a['state'],
      '$country'   => 'BR',
      '$zipcode'   => a['zip'],
      '$phone'     => [a['first_phone_area'], a['first_phone']].reject(&:blank?).join(' '),
    }
  end

  def build_payment_method(order)
    if order['payment_method'] == 'Depósito'
      { '$payment_type' => '$electronic_fund_transfer' }
    elsif order['payment_method'].include?('Crédito')
      {
        '$payment_type' => '$credit_card',
        '$card_last4'   => order['card_number'].try { |n| n[/\d{4}$/] }
      }
    end
  end

  def convert_price(price)
    return if price.blank?
    (price.to_f * 1_000_000).to_i
  end
end
