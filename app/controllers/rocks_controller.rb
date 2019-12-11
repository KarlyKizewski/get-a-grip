class RocksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @rock = Rock.new
  end

  def index
    @rocks = Rock.all
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
    return render_not_found(:forbidden) if @rock.user != current_user
  end

  def update
    @rock = Rock.find_by_id(params[:id])
    return render_not_found if @rock.blank?
    return render_not_found(:forbidden) if @rock.user != current_user
    @rock.update_attributes(rock_params)
    if @rock.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @rock = Rock.find_by_id(params[:id])
    return render_not_found if @rock.blank?
    return render_not_found(:forbidden) if @rock.user != current_user
    @rock.destroy
    redirect_to root_path
  end

  private

  def rock_params
    params.require(:rock).permit(:name, :address, :picture, :description, :message)
  end

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize}", status: status
  end
end
