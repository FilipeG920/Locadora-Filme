class Admin::ClientesController < Admin::BaseController
  before_action :authenticate_admin!
  before_action :set_cliente, only: :show

  def index
    @clientes = Cliente
                  .includes(:emprestimos)
                  .order(:nome)
                  .page(params[:page])
  end

  def show
    @emprestimos = @cliente
                     .emprestimos
                     .includes(copia_filme: :filme)
                     .order(data_emprestimo: :desc)
  end

  private

  def set_cliente
    @cliente = Cliente.find(params[:id])
  end
end
