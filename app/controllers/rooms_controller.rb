class RoomsController < ApplicationController

  def new
    @room = Room.new
    @guesthouse = current_user.guesthouse
    redirect_to root_path, alert: 'Você não tem permissão para realizar essa ação.' unless current_user.guesthouse.id == params[:guesthouse_id].to_i
  end

  def create
    @guesthouse = current_user.guesthouse

    @room = @guesthouse.rooms.new(room_params)
    if @room.save
     redirect_to guesthouse_room_path(@guesthouse, @room), notice: 'Quarto cadastrado com sucesso.'
    else
      render :new
    end
  end

  def show
    @room = Room.find(params[:id])
    @reservation = if params[:reservation]
      Reservation.new(reservation_params)
    else
      Reservation.new
    end
  end

  def edit
    @room = Room.find(params[:id])
    redirect_to root_path, alert: 'Você não tem permissão para realizar essa ação.' unless @room.guesthouse == current_user.guesthouse
  end

  def update
    @room = Room.find(params[:id])
    redirect_to root_path, alert: 'Você não tem permissão para realizar essa ação.' unless @room.guesthouse == current_user.guesthouse
    if @room.update(room_params)
      redirect_to guesthouse_room_path(@room.guesthouse.id, @room.id), notice: 'Quarto atualizado com sucesso.'
    else
      render :edit
    end
  end

  private

  def room_params
    params.require(:room).permit(
      :name, :description, :dimension, :capacity, :daily_rate, :bathroom,
      :balcony, :air_conditioning, :television, :closet, :safe, :accessibility
    )
  end

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :guests_number, :total_price, :room_id)
  end
end
