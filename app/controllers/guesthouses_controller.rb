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
    # @guesthouse = current_user.build_guesthouse(guesthouse_params)
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

  def update
    if @guesthouse.update(guesthouse_params)
      redirect_to guesthouse_path(@guesthouse), notice: 'Pousada atualizada com sucesso.'
    else
      load_payment_methods
      flash.now[:alert] = 'Não foi possível atualizar a pousada.'
      render 'edit'
    end
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
end
