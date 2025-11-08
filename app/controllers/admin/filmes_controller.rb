class Admin::FilmesController < Admin::BaseController
  before_action :set_filme, only: %i[show edit update destroy]

  def index
    @filmes = Filme.includes(:genero).order(:titulo).page(params[:page])

    respond_to do |format|
      format.html
      format.csv do
        send_data Filme.to_csv,
                  filename: "filmes-#{Time.zone.today}.csv",
                  type: "text/csv"
      end
      format.pdf do
        report = FilmesReport.new(Filme.includes(:genero).all)
        send_data report.render,
                  filename: "relatorio_filmes.pdf",
                  type: "application/pdf",
                  disposition: :inline
      end
    end
  end

  def import
    if params[:file].blank?
      redirect_to admin_filmes_path, alert: "Selecione um arquivo CSV para importar."
      return
    end

    result = Filme.import_from_csv(params[:file])

    notice_message = []
    notice_message << "#{result[:created]} filme(s) criado(s)" if result[:created].positive?
    notice_message << "#{result[:updated]} filme(s) atualizado(s)" if result[:updated].positive?
    notice_message = notice_message.to_sentence.presence

    alert_message = result[:errors].presence&.join(" ")

    redirect_to admin_filmes_path, notice: notice_message, alert: alert_message
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

  def show
    @copia_filmes = @filme.copia_filmes.order(created_at: :desc).page(params[:page])
  end

  def edit; end

  def update
    if @filme.update(filme_params)
      redirect_to admin_filmes_path, notice: "Filme atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @filme.destroy
    redirect_to admin_filmes_path, notice: "Filme removido com sucesso!"
  end

  private

  def set_filme
    @filme = Filme.find(params[:id])
  end

  def filme_params
    params.require(:filme).permit(:titulo, :sinopse, :ano_lancamento, :duracao, :genero_id)
  end
end
