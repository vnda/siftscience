require 'rails_helper'

describe EventsController, type: :request do
  let(:order_json) {
    <<-JSON
      {
        "code": "FC7C1DC9F0",
        "token": "b60f935f5b87fda2a7134204d3f76313c74e56688c273b050f4b2c8c20fcd6b1",
        "status": "received",
        "client_id": 4491,
        "slip": true,
        "slip_url": "https://desenvolvedor.moip.com.br/sandbox/Instrucao.do?token=B2T0G1O440F8S0T4Z19614Y3R034I4J5N6T0T0U0Q070J066U0C8H8F0Y289",
        "slip_token": "B2T0G1O440F8S0T4Z19614Y3R034I4J5N6T0T0U0Q070J066U0C8H8F0Y289",
        "payment_method": "Boleto",
        "shipping_method": "transportadora_exemplo",
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
        "card_number": null,
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

  it "sends events" do
    stub_request(:get, 'https://bodystore.vnda.com.br/api/v2/orders/FC7C1DC9F0/shipping_address')
      .to_return(status: 200, body: address_json)
    stub_request(:get, 'https://bodystore.vnda.com.br/api/v2/orders/FC7C1DC9F0/billing_address')
      .to_return(status: 200, body: address_json)
    post '/', {}, { 'RAW_POST_DATA' => order_json }
    raise response.body
  end
end
