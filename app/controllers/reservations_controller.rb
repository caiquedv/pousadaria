class ReservationsController < ApplicationController
  
  def new
    @reservation = if params[:reservation]
      Reservation.new(reservation_params)
    else
      Reservation.new
    end
  end
  
  def create
    @reservation = Reservation.new(reservation_params)    

    @reservation.process_reservation
    @room = @reservation.room

    render 'rooms/show'
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :guests_number, :total_price, :room_id)
  end
end
