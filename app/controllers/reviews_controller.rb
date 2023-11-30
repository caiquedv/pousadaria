class ReviewsController < ApplicationController
  before_action :set_reservation, only: [:new, :create]

  def new
    @review = Review.new
    @reply = params[:reply] ? params[:reply] : false
  end

  def create
    @review = @reservation.reviews.build(review_params.except(:reply))
    
    if @review.save
      
      if review_params[:reply]
        redirect_to reviews_path(@reservation), notice: 'Resposta enviada com sucesso.'
      else
        redirect_to reservation_path(@reservation), notice: 'Avaliação criada com sucesso.'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    if params[:guesthouse_id]
      @reviews = Review.where.not(rate: nil)
                       .joins(reservation: { room: :guesthouse })
                       .where(rooms: { guesthouse_id: params[:guesthouse_id] })
                       .order(created_at: :desc)
    elsif current_user.host?
      @reviews = Review.where.not(rate: nil)
      .joins(reservation: { room: :guesthouse })
      .where(rooms: { guesthouse_id: current_user.guesthouse.id })
      .order(created_at: :desc)
      p @reviews
    elsif current_user.guest?
      @reviews = Review.joins(:reservation)
                      .where(reservations: { user_id: current_user.id })
                      .order(created_at: :desc)
                      
    else
      redirect_to root_path, alert: 'Você não tem permissão para acessar esta página.'
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
  end

  def review_params
    params.require(:review).permit(:rate, :message, :reply)
  end
end
