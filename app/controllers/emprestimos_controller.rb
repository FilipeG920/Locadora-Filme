class EmprestimosController < ApplicationController
  before_action :authenticate_cliente! # garante que apenas clientes logados acessem
  before_action :set_emprestimo, only: [ :show, :edit, :update, :destroy, :devolver ]

  # GET /emprestimos
  def index
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
    @copia_filme = CopiaFilme.find(params[:copia_filme_id])
    unless @copia_filme.disponivel_para_aluguel?
      redirect_to filme_path(@copia_filme.filme), alert: "Esta cópia está indisponível no momento."
      return
    end

    @emprestimo = current_cliente.emprestimos.new(
      copia_filme: @copia_filme,
      data_emprestimo: Time.current,
      data_prevista_devolucao: 7.days.from_now,
      valor_locacao: 10.0
    )

    begin
      Emprestimo.transaction do
        @emprestimo.save!
        @copia_filme.marcar_como_alugada! if @copia_filme.respond_to?(:marcar_como_alugada!)
      end

      redirect_to emprestimos_path, notice: "🎬 Empréstimo realizado com sucesso!"
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
      mensagem = if e.respond_to?(:record) && e.record.present?
                   e.record.errors.full_messages.to_sentence.presence
                 end

      mensagem ||= @emprestimo.errors.full_messages.to_sentence.presence
      mensagem ||= "Não foi possível registrar o empréstimo."
      redirect_to filme_path(@copia_filme.filme), alert: "❌ #{mensagem}"
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
    copia = @emprestimo.copia_filme
    ativo = @emprestimo.ativo?

    begin
      Emprestimo.transaction do
        @emprestimo.destroy!
        if ativo && copia.respond_to?(:marcar_como_disponivel!)
          copia.marcar_como_disponivel!
        end
      end

      redirect_to emprestimos_path, notice: "Empréstimo removido com sucesso."
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed => e
      mensagem = if e.respond_to?(:record) && e.record.present?
                   e.record.errors.full_messages.to_sentence.presence
                 end

      mensagem ||= @emprestimo.errors.full_messages.to_sentence.presence
      mensagem ||= "Não foi possível atualizar o status da cópia."
      redirect_to emprestimos_path, alert: mensagem
    end
  end

  # PATCH /emprestimos/:id/devolver
  def devolver
    if @emprestimo.data_devolucao_efetiva.present?
      redirect_to emprestimos_path, alert: "Este empréstimo já foi devolvido."
      return
    end

    begin
      Emprestimo.transaction do
        @emprestimo.update!(data_devolucao_efetiva: Time.current)
        @emprestimo.copia_filme.marcar_como_disponivel! if @emprestimo.copia_filme.respond_to?(:marcar_como_disponivel!)
      end

      redirect_to emprestimos_path, notice: "📀 Filme devolvido com sucesso!"
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
      mensagem = if e.respond_to?(:record) && e.record.present?
                   e.record.errors.full_messages.to_sentence.presence
                 end

      mensagem ||= @emprestimo.errors.full_messages.to_sentence.presence
      mensagem ||= "Não foi possível registrar a devolução."
      redirect_to emprestimos_path, alert: mensagem
    end
  end

  private

  def set_emprestimo
    @emprestimo = current_cliente.emprestimos.find(params[:id])
  end

  def emprestimo_params
    params.require(:emprestimo).permit(
      :data_prevista_devolucao, :data_devolucao_efetiva,
      :valor_locacao, :valor_multa, :copia_filme_id
    )
  end
end
