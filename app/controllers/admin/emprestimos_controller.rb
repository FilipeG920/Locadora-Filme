class Admin::EmprestimosController < Admin::BaseController
  def index
    @status_filter = params[:status]
    @query = params[:q]

    emprestimos_scope = Emprestimo
                        .includes(:cliente, copia_filme: :filme)
                        .order(data_emprestimo: :desc)

    case @status_filter
    when "pendentes"
      emprestimos_scope = emprestimos_scope.where(data_devolucao_efetiva: nil)
    when "devolvidos"
      emprestimos_scope = emprestimos_scope.where.not(data_devolucao_efetiva: nil)
    end

    if @query.present?
      pattern = "%#{@query.strip}%"
      emprestimos_scope = emprestimos_scope
                           .left_joins(:cliente)
                           .left_joins(copia_filme: :filme)
                           .where(search_condition, pattern: pattern)
                           .distinct
    end

    @emprestimos = emprestimos_scope
    export_collection = emprestimos_scope.load

    respond_to do |format|
      format.html
      format.csv do
        send_data Emprestimo.to_csv(export_collection),
                  filename: "emprestimos-#{Time.zone.now.strftime('%Y%m%d')}.csv",
                  type: "text/csv"
      end
      format.pdf do
        send_data EmprestimosReport.new(export_collection).render,
                  filename: "relatorio-emprestimos-#{Time.zone.now.strftime('%Y%m%d')}.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
      end
    end
  end

  def show
    @emprestimo = Emprestimo
                  .includes(:cliente, copia_filme: :filme)
                  .find(params[:id])
  end

  def import
    if params[:file].blank?
      redirect_to admin_emprestimos_path, alert: "Selecione um arquivo CSV para importar."
      return
    end

    Emprestimo.import_from_csv(params[:file])
    redirect_to admin_emprestimos_path, notice: "Importação de empréstimos concluída com sucesso."
  rescue StandardError => e
    redirect_to admin_emprestimos_path, alert: "Não foi possível importar os empréstimos: #{e.message}"
  end

  private

  def search_condition
    <<~SQL
      LOWER(clientes.nome) LIKE LOWER(:pattern)
      OR LOWER(clientes.email) LIKE LOWER(:pattern)
      OR LOWER(filmes.titulo) LIKE LOWER(:pattern)
    SQL
  end
end
