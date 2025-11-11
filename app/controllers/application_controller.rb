class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Para o formulário de cadastro (sign_up)
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :nome, :telefone, :endereco, :data_nascimento ])

    # Para o formulário de edição de conta (account_update)
    devise_parameter_sanitizer.permit(:account_update, keys: [ :nome, :telefone, :endereco, :data_nascimento, :current_password ])
  end
end
