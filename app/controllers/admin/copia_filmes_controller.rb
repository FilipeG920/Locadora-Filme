class Admin::CopiaFilmesController < Admin::BaseController
  include CopiaFilmeManagement

  before_action :set_filme
  before_action :set_copia_filme, only: %i[edit update destroy]

  def new
    @copia_filme = build_copia_filme
  end

  def create
    @copia_filme = build_copia_filme
    @copia_filme.assign_attributes(copia_filme_params)

    if @copia_filme.save
      redirect_to admin_filme_path(@filme), notice: "Cópia cadastrada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @copia_filme.update(copia_filme_params)
      redirect_to admin_filme_path(@filme), notice: "Cópia atualizada com sucesso!", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @copia_filme.destroy!
    redirect_to admin_filme_path(@filme), notice: "Cópia removida com sucesso!", status: :see_other
  end

  private

  def set_filme
    @filme = Filme.find(params[:filme_id])
  end

  def copia_filmes_scope
    @filme.copia_filmes
  end

  def build_copia_filme
    copia_filmes_scope.build
  end

  def copia_filme_params
    params.require(:copia_filme).permit(:status, :tipo_midia)
  end
end
