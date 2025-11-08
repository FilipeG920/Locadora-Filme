class Admin::GenerosController < Admin::BaseController
  before_action :authenticate_admin!
  before_action :set_genero, only: [ :edit, :update, :destroy ]

  def index
    @generos = Genero.order(:nome).page(params[:page])

    respond_to do |format|
      format.html
      format.csv do
        send_data Genero.to_csv,
                  filename: "generos-#{Time.zone.today}.csv",
                  type: "text/csv"
      end
    end
  end

  def new
    @genero = Genero.new
  end

  def create
    @genero = Genero.new(genero_params)
    if @genero.save
      redirect_to admin_generos_path, notice: "Gênero criado com sucesso!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @genero.update(genero_params)
      redirect_to admin_generos_path, notice: "Gênero atualizado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    @genero.destroy
    redirect_to admin_generos_path, notice: "Gênero removido com sucesso!"
  end

  def import
    if params[:file].blank?
      redirect_to admin_generos_path, alert: "Selecione um arquivo CSV para importar."
      return
    end

    result = Genero.import_from_csv(params[:file])

    notice_message = []
    notice_message << "#{result[:created]} gênero(s) criado(s)" if result[:created].positive?
    notice_message << "#{result[:updated]} gênero(s) atualizado(s)" if result[:updated].positive?
    notice_message = notice_message.to_sentence.presence

    alert_message = result[:errors].presence&.join(" ")

    redirect_to admin_generos_path, notice: notice_message, alert: alert_message
  end

  private

  def set_genero
    @genero = Genero.find(params[:id])
  end

  def genero_params
    params.require(:genero).permit(:nome)
  end
end
