class Admin::EmprestimosController < Admin::BaseController
  def index
    @status_filter = params[:status]
    @query = params[:q]

    @emprestimos = Emprestimo
                    .includes(:cliente, copia_filme: :filme)
                    .order(data_emprestimo: :desc)

    case @status_filter
    when "pendentes"
      @emprestimos = @emprestimos.where(data_devolucao_efetiva: nil)
    when "devolvidos"
      @emprestimos = @emprestimos.where.not(data_devolucao_efetiva: nil)
    end

    if @query.present?
      pattern = "%#{@query.strip}%"
      @emprestimos = @emprestimos
                      .left_joins(:cliente)
                      .left_joins(copia_filme: :filme)
                      .where(search_condition, pattern: pattern)
                      .distinct
    end
  end

  def show
    @emprestimo = Emprestimo
                  .includes(:cliente, copia_filme: :filme)
                  .find(params[:id])
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
