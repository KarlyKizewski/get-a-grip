class RocksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @rock = Rock.new
  end

  def index
  end

  def show
    @rock = Rock.find_by_id(params[:id])
    return render_not_found if @rock.blank?
  end

  def create
    @rock = current_user.rocks.create(rock_params)
    if @rock.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @rock = Rock.find_by_id(params[:id])
    return render_not_found if @rock.blank?
  end

  def update
    @rock = Rock.find_by_id(params[:id])
    return render_not_found if @rock.blank?
    @rock.update_attributes(rock_params)

    if @rock.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  private

  def rock_params
    params.require(:rock).permit(:name, :address, :description, :message)
  end

  def render_not_found
    render plain: 'Not Found', status: :not_found
  end
end
