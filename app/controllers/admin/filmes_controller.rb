class Admin::FilmesController < Admin::BaseController
  def index
    @filmes = Filme.includes(:genero).order(:titulo).page(params[:page])

    respond_to do |format|
      format.html
      format.pdf do
        report = FilmesReport.new(Filme.includes(:genero).all)
        send_data report.render,
                  filename: "relatorio_filmes.pdf",
                  type: "application/pdf",
                  disposition: :inline
      end
    end
  end

  def new
    @filme = Filme.new
  end

  def create
    @filme = Filme.new(filme_params)
    if @filme.save
      redirect_to admin_filmes_path, notice: "Filme criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @filme = Filme.find(params[:id])
  end

  def update
    @filme = Filme.find(params[:id])
    if @filme.update(filme_params)
      redirect_to admin_filmes_path, notice: "Filme atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @filme = Filme.find(params[:id])
    @filme.destroy
    redirect_to admin_filmes_path, notice: "Filme removido com sucesso!"
  end

  private

  def filme_params
    params.require(:filme).permit(:titulo, :sinopse, :ano_lancamento, :duracao, :genero_id)
  end
end
