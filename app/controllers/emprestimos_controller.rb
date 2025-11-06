class EmprestimosController < ApplicationController
  before_action :authenticate_cliente! # garante que apenas clientes logados acessem
  before_action :set_emprestimo, only: [:show, :edit, :update, :destroy, :devolver]

  # GET /emprestimos
  def index
    # Mostra apenas os empréstimos do cliente logado
    @emprestimos = current_cliente.emprestimos.includes(copia_filme: :filme)
  end

  # GET /emprestimos/:id
  def show
  end

  # GET /emprestimos/new
  def new
    @emprestimo = Emprestimo.new
  end

  # POST /emprestimos
  def create
    copia = CopiaFilme.find(params[:copia_filme_id])

    if copia.status == "Alugado"
      redirect_back fallback_location: filmes_path, alert: "Essa cópia já está alugada."
      return
    end

    @emprestimo = Emprestimo.new(
      cliente: current_cliente,
      copia_filme: copia,
      data_emprestimo: Time.current,
      data_prevista_devolucao: 7.days.from_now,
      valor_locacao: 10.0
    )

    if @emprestimo.save
      copia.update(status: "Alugado")
      redirect_to emprestimos_path, notice: "🎬 Empréstimo realizado com sucesso!"
    else
      redirect_back fallback_location: filmes_path, alert: "Erro ao realizar o empréstimo."
    end
  end

  # GET /emprestimos/:id/edit
  def edit
  end

  # PATCH/PUT /emprestimos/:id
  def update
    if @emprestimo.update(emprestimo_params)
      redirect_to @emprestimo, notice: "Empréstimo atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /emprestimos/:id
  def destroy
    @emprestimo.destroy
    redirect_to emprestimos_path, notice: "Empréstimo removido com sucesso."
  end

  # PATCH /emprestimos/:id/devolver
  def devolver
    if @emprestimo.data_devolucao_efetiva.present?
      redirect_to emprestimos_path, alert: "Este empréstimo já foi devolvido."
      return
    end

    @emprestimo.update(data_devolucao_efetiva: Time.current)

    # Libera a cópia
    @emprestimo.copia_filme.update(status: "Disponível")

    redirect_to emprestimos_path, notice: "📀 Filme devolvido com sucesso!"
  end

  private

  def set_emprestimo
    @emprestimo = Emprestimo.find(params[:id])
  end

  def emprestimo_params
    params.require(:emprestimo).permit(
      :data_prevista_devolucao, :data_devolucao_efetiva,
      :valor_locacao, :valor_multa, :copia_filme_id
    )
  end
end


