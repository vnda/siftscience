require 'rails_helper'

describe EventsController, type: :request do
  before do
    ENV['VNDA_API_HOST'] = 'shop.com.br'
    ENV['VNDA_API_USER'] = 'lorem'
    ENV['VNDA_API_PASSWORD'] = 'ipsum'
  end
  let(:order_json) {
    <<-JSON
      {
        "code": "FC7C1DC9F0",
        "token": "b60f935f5b87fda2a7134204d3f76313c74e56688c273b050f4b2c8c20fcd6b1",
        "status": "received",
        "client_id": 4491,
        "slip": false,
        "slip_url": null,
        "slip_token": null,
        "payment_method": "Visa - Crédito",
        "shipping_method": "correios_pac",
        "shipping_price": 29.82,
        "subtotal": 133.7,
        "discount_price": 0.0,
        "total": 163.52,
        "tracking_code": null,
        "updated_at": "2014-08-04T16:43:43.375-03:00",
        "received_at": "2014-08-04T16:43:06.216-03:00",
        "confirmed_at": null,
        "shipped_at": null,
        "shipping_tracked_at": null,
        "delivered_at": null,
        "canceled_at": null,
        "installments": 1,
        "card_number": "************1112",
        "extra": {},
        "email": "fulano@examplo.com.br",
        "delivery_days": 4
      }
    JSON
  }

  let(:address_json) {
    <<-JSON
      {
        "first_name": "Fulano",
        "last_name": "Silva",
        "email": "fulano@examplo.com.br",
        "documents": {
          "cpf": "74394852625"
        },
        "first_phone_area": "51",
        "first_phone": "34567890",
        "second_phone_area": "",
        "second_phone": "",
        "street_name": "Rua Germano Petersen",
        "street_number": "501",
        "complement": "Sala 401",
        "neighborhood": "Auxiliadora",
        "company_name": "",
        "zip": "90540140",
        "city": "Porto Alegre",
        "state": "RS",
        "reference": null
      }
    JSON
  }

  let(:items_json) {
    <<-JSON
      [
        {
          "id": 359,
          "variant_id": 409,
          "quantity": 1,
          "price": 25.5,
          "total": 25.5,
          "weight": 0.1,
          "width": 11,
          "height": 2,
          "length": 16,
          "extra": {},
          "picture_url": null,
          "reference": "1070",
          "sku": "1070",
          "product_name": "Sal Granulado Body & Bubble Blue Berry",
          "variant_name": null
        },
        {
          "id": 360,
          "variant_id": 305,
          "quantity": 3,
          "price": 26.9,
          "total": 80.7,
          "weight": 0.1,
          "width": 11,
          "height": 2,
          "length": 16,
          "extra": {},
          "picture_url": null,
          "reference": "3811",
          "sku": "3811",
          "product_name": "Condicionador Secos e Danificados (Geléia Real)",
          "variant_name": null
        }
      ]
    JSON
  }

  specify "#transaction" do
    stub_request(:get, 'https://lorem:ipsum@shop.com.br/api/v2/orders/FC7C1DC9F0/shipping_address')
      .to_return(status: 200, body: address_json)
    stub_request(:get, 'https://lorem:ipsum@shop.com.br/api/v2/orders/FC7C1DC9F0/billing_address')
      .to_return(status: 200, body: address_json)
    stub_request(:get, 'https://lorem:ipsum@shop.com.br/api/v2/orders/FC7C1DC9F0/items')
      .to_return(status: 200, body: items_json)
    api_stub = stub_request(:post, 'https://api.siftscience.com/v203/events')
      .to_return(body: '{ "status" : 0 , "error_message" : "OK" , "time" : 1407502567 , "request" : {} }')

    post '/transaction', {}, { 'RAW_POST_DATA' => order_json }

    expect(api_stub).to have_been_requested
  end
end
