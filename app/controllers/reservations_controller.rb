class ReservationsController < ApplicationController
  
  def index
    @reservations = Reservation.active.where(user_id: current_user.id) if current_user.guest?
  end

  def new
    if session[:reservation_params]
      @reservation = Reservation.new(session[:reservation_params])
      @payment_methods = '' 
      
      @reservation.room.guesthouse.payment_methods.each do |p_m|      
        @payment_methods += "#{p_m.name} "
      end

    else
      Reservation.new
    end

  end
  
  def create
    @reservation = current_user.reservations.new(session[:reservation_params])
    @reservation.process_reservation

    if @reservation.save
      redirect_to reservations_path
    else
      flash.now[:alert] = 'Verifique novamente as informações da reserva e disponibilidade.'
      render 'new'
    end
  end

  def verify_reservation    
    @reservation = Reservation.new(reservation_params)    

    @reservation.process_reservation
    @room = @reservation.room
    
    render 'rooms/show'
  end

  def reservation_with_auth    
    session[:reservation_params] = {
      start_date: params[:reservation][:start_date],  
      end_date: params[:reservation][:end_date],
      guests_number: params[:reservation][:guests_number],
      total_price: params[:reservation][:total_price],
      room_id: params[:room_id]
    }

    if user_signed_in?      
      redirect_to new_room_reservation_path
    else
      redirect_to new_user_session_path
    end 
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    
    if @reservation.user == current_user && @reservation.start_date > 7.days.from_now
      @reservation.update(status: :cancelled)
      redirect_to reservations_path, notice: 'Reserva cancelada com sucesso.'
    else
      redirect_to reservations_path, alert: 'Não foi possível cancelar a reserva.'
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :guests_number, :total_price, :room_id)
  end
end
