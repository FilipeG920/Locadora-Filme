class EmprestimosController < ApplicationController
  before_action :set_emprestimo, only: %i[ show edit update destroy ]

  # GET /emprestimos or /emprestimos.json
  def index
    @emprestimos = Emprestimo.all
  end

  # GET /emprestimos/1 or /emprestimos/1.json
  def show
  end

  # GET /emprestimos/new
  def new
    @emprestimo = Emprestimo.new
    @copias_disponiveis = CopiaFilme.where(status: "Disponível")
  end

  # GET /emprestimos/1/edit
  def edit
  end

  # POST /emprestimos or /emprestimos.json
  def create
    @copia = CopiaFilme.find(emprestimo_params[:copia_filme_id])
    @emprestimo = Emprestimo.new(
      cliente: current_cliente,  # Pega o cliente logado (requer Devise)
      copia_filme: @copia,
      data_emprestimo: Time.current,
      data_prevista_devolucao: Time.current + 3.days, # Ex: 3 dias de aluguel
      valor_locacao: 5.00 # Ex: Valor fixo
    )

    respond_to do |format|
      if @emprestimo.save
        @copia.update(status: "Alugado")
        format.html { redirect_to @emprestimo, notice: "Filme alugado com sucesso." }
        format.json { render :show, status: :created, location: @emprestimo }
      else
        @copias_disponiveis = CopiaFilme.where(status: "Disponível")
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @emprestimo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emprestimos/1 or /emprestimos/1.json
  def update
    respond_to do |format|
      if @emprestimo.update(emprestimo_params)
        format.html { redirect_to @emprestimo, notice: "Emprestimo was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @emprestimo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @emprestimo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emprestimos/1 or /emprestimos/1.json
  def destroy
    @emprestimo.destroy!

    respond_to do |format|
      format.html { redirect_to emprestimos_path, notice: "Emprestimo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_emprestimo
      @emprestimo = Emprestimo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def emprestimo_params
      params.expect(emprestimo: [ :cliente_id, :copia_filme_id, :data_emprestimo, :data_prevista_devolucao, :data_devolucao_efetiva, :valor_locacao, :valor_multa ])
    end
end
