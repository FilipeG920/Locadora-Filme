class Admin::ClientesController < Admin::BaseController
  before_action :authenticate_admin!
  before_action :set_cliente, only: :show

  def index
    clientes_scope = Cliente
                      .includes(:emprestimos)
                      .order(:nome)

    @clientes = clientes_scope.page(params[:page])
    export_collection = clientes_scope.load

    respond_to do |format|
      format.html
      format.csv do
        send_data Cliente.to_csv(export_collection),
                  filename: "clientes-#{Time.zone.now.strftime('%Y%m%d')}.csv",
                  type: "text/csv"
      end
      format.pdf do
        send_data ClientesReport.new(export_collection).render,
                  filename: "relatorio-clientes-#{Time.zone.now.strftime('%Y%m%d')}.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
      end
    end
  end

  def show
    @emprestimos = @cliente
                     .emprestimos
                     .includes(copia_filme: :filme)
                     .order(data_emprestimo: :desc)
  end

  def import
    if params[:file].blank?
      redirect_to admin_clientes_path, alert: "Selecione um arquivo CSV para importar."
      return
    end

    Cliente.import_from_csv(params[:file])
    redirect_to admin_clientes_path, notice: "Importação de clientes concluída com sucesso."
  rescue StandardError => e
    redirect_to admin_clientes_path, alert: "Não foi possível importar os clientes: #{e.message}"
  end

  private

  def set_cliente
    @cliente = Cliente.find(params[:id])
  end
end
