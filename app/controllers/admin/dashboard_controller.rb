class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    @generos = Genero.all
    @filmes = Filme.all
  end
end
