class ShopsController < ApplicationController
  before_action :require_authentication

  def index
    @shops = Shop.all
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      redirect_to edit_shop_path(@shop), notice: 'Loja cadastrada com sucesso'
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
