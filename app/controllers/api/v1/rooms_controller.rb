class Api::V1::RoomsController < Api::V1::ApiController
  def index
    guesthouse = Guesthouse.find_by(id: params[:guesthouse_id])

    if guesthouse
      rooms = guesthouse.rooms.where(active: true)
      render status: 200, json: rooms 
    else
      render status: 404, json: { error: 'Guesthouse not found' }
    end
  end

  def availability
    room = Room.find_by(id: params[:id])
    return render status: 404, json: { error: 'Room not found' } unless room
  
    start_date = params[:start_date].to_date
    end_date = params[:end_date].to_date
    guests_number = params[:guests_number].to_i
  
    reservation = Reservation.new(
      room: room,
      start_date: start_date,
      end_date: end_date,
      guests_number: guests_number
    )
  
    reservation.process_reservation

    if reservation.is_available
      render status: 200, json: { available: true, total_price: reservation.total_price }
    else
      render status: 200, json: { available: false, error: 'Room is not available for the selected dates' }
    end
  end
  

  
end