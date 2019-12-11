class RocksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def new
    @rock = Rock.new
  end

  def index
  end

  def create
    @rock = current_user.rocks.create(rock_params)
    if @rock.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def rock_params
    params.require(:rock).permit(:name, :address, :description, :message)
  end
end
