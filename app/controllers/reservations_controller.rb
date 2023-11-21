class ReservationsController < ApplicationController
  
  def index
    if current_user.guest?
      @reservations = current_user.reservations.where.not(status: :cancelled)
      @title = 'Reservas'
    else
      if params[:only_active]
        @reservations = Reservation.joins(:room)
        .where(rooms: { guesthouse_id: current_user.guesthouse.id })
        .where(status: :active)
        @title = 'Estadias Ativas'
      else
        guesthouse = current_user.guesthouse
        @reservations = Reservation.joins(:room)
                                  .where(rooms: { guesthouse_id: guesthouse.id })
                                  .where(status: :pending)
        
        @title = 'Reservas'
      end
    end
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

  def show
    @reservation = Reservation.find(params[:id])    
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
    elsif current_user.host? && current_user.guesthouse == @reservation.room.guesthouse
      if Time.zone.today >= @reservation.start_date + 2.days && @reservation.status == 'pending'
        @reservation.update(status: :cancelled)
        redirect_to reservations_path, notice: 'Reserva cancelada com sucesso.'
      else
        flash.now[:alert] = 'Não foi possível cancelar a reserva.'
        redirect_to reservations_path
      end
    else
      flash.now[:alert] = 'Não foi possível cancelar a reserva.'
      redirect_to reservations_path
    end
    
  end
  

  def check_in
    @reservation = Reservation.find(params[:id])
  
    if current_user.guesthouse == @reservation.room.guesthouse && Time.zone.today >= @reservation.start_date
      @reservation.update(status: :active, checked_in_at: Time.zone.now)
      redirect_to reservations_path, notice: 'Check-in realizado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível realizar o check-in, ainda há prazo em aberto.'
    end
  end  

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :guests_number, :total_price, :room_id)
  end
end
