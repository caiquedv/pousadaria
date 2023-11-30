class Api::V1::GuesthousesController < Api::V1::ApiController
  def index
    if params[:query]
      guesthouses = Guesthouse.all_active.where('brand_name LIKE ?', "%#{params[:query]}%")
    else
      guesthouses = Guesthouse.all_active
    end

    render status: 200, json: guesthouses
  end

  def show
    guesthouse = Guesthouse.find_by(id: params[:id])

    if guesthouse
      average_rating = Review.average_rating_for_guesthouse(guesthouse.id)

      render status: 200, 
      json: guesthouse.as_json(except: [:tax_code, :corporate_name])
                      .merge(average_rating: average_rating)
    else
      render status: 404, json: { error: 'Guesthouse not found' }
    end
  end
end