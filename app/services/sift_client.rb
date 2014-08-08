class SiftClient
  API_URL = 'https://api.siftscience.com/v203/events'

  def initialize(order, shipping_address, billing_address)
    @order = order
    @shipping = shipping_address
    @billing = billing_address
  end

  def send!
    response = Excon.post(API_URL, body: data.to_json)
    Rails.logger.info('Siftscience API Response: ' + response.body)
  end

  private

  def data
    {
      '$type' => '$transaction',
      '$api_key' => api_key,
      '$user_id' => @order['client_id'].to_s,
      '$user_email' => @order['email'],
      '$amount' => convert_price(@order['total']),
      '$transaction_status' => '$success',
      '$order_id' => @order['code'],
      '$currency_code' => 'BRL',
      '$payment_method' => build_payment_method,
      '$billing_address'  => build_address(@billing),
      '$shipping_address' => build_address(@shipping)
    }
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

  def build_payment_method
    if @order['payment_method'] == 'Depósito'
      { '$payment_type' => '$electronic_fund_transfer' }
    elsif @order['payment_method'].include?('Crédito')
      {
        '$payment_type' => '$credit_card',
        '$card_last4'   => @order['card_number'].try { |n| n[/\d{4}$/] }
      }
    end
  end

  def convert_price(price)
    return if price.blank?
    (price.to_f * 1_000_000).to_i
  end

  def api_key
    ENV['SIFT_API_KEY']
  end
end
