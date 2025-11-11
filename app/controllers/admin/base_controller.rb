class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :verificar_admin

  private

  def verificar_admin
    redirect_to root_path, alert: "Acesso negado!" unless current_admin.present?
  end
end
