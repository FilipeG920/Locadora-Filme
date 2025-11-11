class CopiaFilmesController < ApplicationController
  include CopiaFilmeManagement

  before_action :set_copia_filme, only: :show

  def index
    @copia_filmes = copia_filmes_scope.includes(:filme).order(created_at: :desc).page(params[:page])
  end

  def show; end

  private

  def copia_filmes_scope
    CopiaFilme.all
  end
end
