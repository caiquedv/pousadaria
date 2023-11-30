class GuesthousesController < ApplicationController  
  before_action :set_guesthouse, only: [:show, :edit, :update]
  before_action :check_ownership, only: [:edit, :update]

  skip_before_action :check_guesthouse_registration, only: [:new, :create]
  
  def new
    return redirect_to_root_with_alert('Você não tem permissão para realizar essa ação.') if current_user.guest?
    return redirect_to_root_with_alert('Você já possui uma pousada cadastrada.') if current_user.guesthouse.present?

    load_payment_methods
    @guesthouse = Guesthouse.new
  end

  def create
    return redirect_to_root_with_alert('Você já possui uma pousada cadastrada.') if current_user.guesthouse.present?

    @guesthouse = Guesthouse.new(guesthouse_params)
    @guesthouse.user_id = current_user.id

    if @guesthouse.save
      redirect_to root_path, notice: 'Pousada cadastrada com sucesso!'
    else
      load_payment_methods
      flash.now[:notice] = 'Pousada não cadastrada!'
      render 'new'
    end
  end
  
  def edit
    return redirect_to_root_with_alert('Você não tem permissão para realizar essa ação.') if current_user.guest?
    load_payment_methods
  end

  def show
    @rating = Review.average_rating_for_guesthouse(@guesthouse.id)
    @last_three_reviews = Review.joins(reservation: { room: :guesthouse })
                                .where(rooms: { guesthouse_id: @guesthouse.id })
                                .where.not(rate: nil)
                                .order(created_at: :desc)
                                .limit(3)
  end

  def update
    if @guesthouse.update(guesthouse_params)
      redirect_to guesthouse_path(@guesthouse), notice: 'Pousada atualizada com sucesso.'
    else
      load_payment_methods
      flash.now[:alert] = 'Não foi possível atualizar a pousada.'
      render 'edit'
    end
  end

  def city
    @city_name = params[:city_slug].split('-').join(' ').titleize
    @guesthouses = Guesthouse.where(city: @city_name, active: true).order(brand_name: :asc) 
  end

  def search   
    query = params[:query]
    if query
      @guesthouses = Guesthouse.where('brand_name LIKE ? OR district LIKE ? OR city LIKE ?', 
                                      "%#{query}%", "%#{query}%", "%#{query}%")
                              .order(brand_name: :asc)
      @search_filters = ["Termo buscado: #{query}"]
    else
      if params[:advanced_search].values.all? { |value| value.blank? || value == '0' }
        flash.now[:alert] = 'Nenhum filtro de busca foi selecionado.'
        return render 'advanced_search'
      end

      @advanced_search = AdvancedSearch.new(search_params)
      @guesthouses = @advanced_search.search_guesthouses       
      @search_filters = ["Filtros ativos:"] + active_filters(search_params)
    end

      @search_phrase = '1 registro encontrado' if @guesthouses.count == 1
      @search_phrase = "#{@guesthouses.count} registros encontrados" if @guesthouses.count > 1
      @search_phrase = 'Nenhum resultado para o termo' if @guesthouses.count == 0      
  end

  def advanced_search
  
  end

  private

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:id])
  end

  def guesthouse_params
    params.require(:guesthouse).permit(
      :brand_name, :corporate_name, :tax_code, 
      :phone, :email, :address, :district, 
      :state, :city, :postal_code, :description, 
      :accepts_pets, :usage_policy, :check_in, 
      :check_out, :active, payment_method_ids: []
    )
  end

  def check_ownership
    redirect_to root_path, alert: 'Você não tem permissão para realizar essa ação.' unless @guesthouse.user == current_user
  end

  def redirect_to_root_with_alert(alert_message)
    redirect_to root_path, alert: alert_message
  end

  def load_payment_methods
    @payment_methods = PaymentMethod.all
  end

  def search_params
    params.require(:advanced_search).permit(
      :city, :district, :capacity, :accepts_pets, 
      :bathroom, :balcony, :air_conditioning, 
      :television, :closet, :safe, :accessibility
    )
  end

  def active_filters(search_params)
    filters = []
  
    search_params.each do |key, value|
      next if value.blank? || value == '0'
      if Guesthouse.attribute_names.include?(key)
        if key == 'accepts_pets'
          filter_text = I18n.t("activerecord.attributes.guesthouse.#{key}") 
        else
          label = I18n.t("activerecord.attributes.guesthouse.#{key}")
          filter_text = "#{label}: #{value}"          
        end
      elsif Room.attribute_names.include?(key)      
        if key == 'capacity'
          label = I18n.t("activerecord.attributes.room.#{key}") 
          filter_text = "#{label}: #{value} pessoas"
        else
          filter_text = I18n.t("activerecord.attributes.room.#{key}") 
        end
      end
  
      filters << filter_text
    end
  
    filters
  end
end
