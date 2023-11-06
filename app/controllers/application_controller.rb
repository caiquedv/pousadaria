class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_guesthouse_registration

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
  end

  def check_guesthouse_registration
    return unless user_signed_in? && current_user.host? && current_user.guesthouse.nil?

    is_exempt = (controller_name == 'sessions' && action_name == 'destroy') 

    redirect_to new_guesthouse_path unless is_exempt
  end
end
