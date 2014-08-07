class SiftClient
  API_URL = 'https://api.siftscience.com/v203/events'

  def initialize(order, shipping_address, billing_address)
    @order = order
    @shipping = shipping_address
    @billing = billing_address
  end

  def send!
    Excon.post(API_URL, body: data.to_json)
  end

  private

  def data
    {
      '$type'    => '$create_order',
      '$api_key' => api_key,
      '$user_id' => @order['client_id'].to_s,

      '$order_id'      => @order['code'],
      '$user_email'    => @order['email'],
      '$amount'        => @order['total'].try { |t| (t.to_f * 1_000_000).to_i },
      '$currency_code' => 'BRL',

      '$billing_address'  => build_address(@billing),
      '$shipping_address' => build_address(@shipping),

      '$items' => @order.fetch('items', []).map do |i|
        {
          '$item_id'       => i['reference'],
          '$product_title' => [i['product_name'], i['variant_name']].reject(&:blank?).join(' '),
          '$price'         => i['price'].to_s,
          '$currency_code' => 'BRL',
          '$quantity'      => i['quantity'],
          '$sku'           => i['sku']
        }
      end
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

  def api_key
    ENV['SIFT_API_KEY']
  end
end
