class AddressesController < ApplicationController
  def index
    @addresses = Address.where(user_id: current_user.id)
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.save
    redirect_to addresses_path
  end

  def edit
    @address = Address.find(params[:id])
    items = Item.all
    @items = items.where(address_id: params[:id])
  end

  def update
    @address = Address.find(params[:id])
    @item = Item.all
    @items = @item.where(address_id: params[:id])
    @limit = params[:limit]

    @address.update(address_params)

    if @items.count >= @address.limit
      flash[:notice] = "#{@address.name}に存在するモノは#{@items.count}です。登録上限です。"
      @address.update(limit: @items.count)
      redirect_to edit_address_path(@address)
    else
      redirect_to addresses_path
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to addresses_path
  end

  def show
  end

  private

  def address_params
    params.require(:address).permit(:name, :limit, :user_id)
  end
end
