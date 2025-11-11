module CopiaFilmeManagement
  extend ActiveSupport::Concern

  private

  def copia_filmes_scope
    CopiaFilme.all
  end

  def build_copia_filme
    copia_filmes_scope.build
  end

  def set_copia_filme
    @copia_filme = copia_filmes_scope.find(params[:id])
  end

  def copia_filme_params
    params.require(:copia_filme).permit(:filme_id, :status, :tipo_midia)
  end
end
