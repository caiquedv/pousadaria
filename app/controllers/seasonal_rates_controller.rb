class SeasonalRatesController < ApplicationController
  def new
    @room =  Room.find(params[:room_id])
    @seasonal_rate = SeasonalRate.new
  end

  def create
     @room = current_user.rooms.find(params[:room_id])

    if @room
      @seasonal_rate = @room.seasonal_rates.build(seasonal_rate_params)

      if @seasonal_rate.save
        redirect_to guesthouse_room_path(@room.guesthouse.id, @room.id), notice: 'Preço adicionado com sucesso.'
      else
        render :new
      end
    end
  end

  def seasonal_rate_params
    params.require(:seasonal_rate).permit(
      :description, :start_date, :end_date, :daily_rate
    )
  end
end
