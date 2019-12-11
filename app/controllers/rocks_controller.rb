class RocksController < ApplicationController
  def new
    @rock = Rock.new
  end

  def index
  end

  def create
    @rock = Rock.create(rock_params)
    redirect_to root_path
  end

  private

  def rock_params
    params.require(:rock).permit(:name, :address, :description, :message)
  end
end
