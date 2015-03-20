class ShopsController < ApplicationController
  before_action :require_authentication

  def index
    @shops = Shop.all

    response = Excon.get("https://api3.siftscience.com/v3/partners/#{ENV["PARTNER_ID"]}/accounts", :headers => {'Authorization' => "Basic #{ENV["PARTNER_KEY"]}"})
    @accounts = MultiJson.load(response.body)
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save

      if params[:subdomain].present?
        response = Excon.post("https://api3.siftscience.com/v3/partners/#{ENV["PARTNER_ID"]}/accounts",
          :body => URI.encode_www_form(
            :site_url => @shop.vnda_api_host,
            :site_email => "#{params[:subdomain]}@vnda.com.br",
            :analyst_email => "#{params[:subdomain]}@vnda.com.br",
            :password => "#{params[:subdomain]}1101"
          ),
          :headers => {'Authorization' => "Basic #{ENV["PARTNER_KEY"]}"})
        account = MultiJson.load(response.body)
        @shop.sift_api_key = account[ Rails.env.production? ? "production" : "sandbox" ]["api_keys"].first["key"]
        @shop.save
      end

      redirect_to edit_shop_path(@shop), notice: "Loja cadastrada com sucesso #{account}"
    else
      render :new
    end
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])
    if @shop.update(shop_params)
      redirect_to edit_shop_path(@shop), notice: 'Loja atualizada com sucesso'
    else
      render :edit
    end
  end

  def destroy
    Shop.find(params[:id]).destroy!
    redirect_to shops_path, notice: 'Loja removida com sucesso'
  end

  private

  def shop_params
    params.require(:shop).permit(
      :sift_api_key, :vnda_api_host, :vnda_api_user, :vnda_api_password
    )
  end
end
