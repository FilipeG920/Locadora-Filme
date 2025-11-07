class Admin::GenerosController < Admin::BaseController
  before_action :authenticate_admin!
  before_action :set_genero, only: [:edit, :update, :destroy]

  def index
    @generos = Genero.all
  end

  def new
    @genero = Genero.new
  end

  def create
    @genero = Genero.new(genero_params)
    if @genero.save
      redirect_to admin_generos_path, notice: "Gênero criado com sucesso!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @genero.update(genero_params)
      redirect_to admin_generos_path, notice: "Gênero atualizado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    @genero.destroy
    redirect_to admin_generos_path, notice: "Gênero removido com sucesso!"
  end

  private

  def set_genero
    @genero = Genero.find(params[:id])
  end

  def genero_params
    params.require(:genero).permit(:nome)
  end
end
