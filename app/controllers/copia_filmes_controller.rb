class CopiaFilmesController < ApplicationController
  before_action :set_copia_filme, only: %i[ show edit update destroy ]

  # GET /copia_filmes or /copia_filmes.json
  def index
    @copia_filmes = CopiaFilme.all
  end

  # GET /copia_filmes/1 or /copia_filmes/1.json
  def show
  end

  # GET /copia_filmes/new
  def new
    @copia_filme = CopiaFilme.new
  end

  # GET /copia_filmes/1/edit
  def edit
  end

  # POST /copia_filmes or /copia_filmes.json
  def create
    @copia_filme = CopiaFilme.new(copia_filme_params)

    respond_to do |format|
      if @copia_filme.save
        format.html { redirect_to @copia_filme, notice: "Copia filme was successfully created." }
        format.json { render :show, status: :created, location: @copia_filme }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @copia_filme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /copia_filmes/1 or /copia_filmes/1.json
  def update
    respond_to do |format|
      if @copia_filme.update(copia_filme_params)
        format.html { redirect_to @copia_filme, notice: "Copia filme was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @copia_filme }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @copia_filme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /copia_filmes/1 or /copia_filmes/1.json
  def destroy
    @copia_filme.destroy!

    respond_to do |format|
      format.html { redirect_to copia_filmes_path, notice: "Copia filme was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_copia_filme
      @copia_filme = CopiaFilme.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def copia_filme_params
      params.expect(copia_filme: [ :filme_id, :status, :tipo_midia ])
    end
end
