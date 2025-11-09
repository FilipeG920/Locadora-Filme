require "prawn/table"

class ClientesReport
  def initialize(clientes)
    @clientes = normalize_collection(clientes)
  end

  def render
    Prawn::Document.new(page_size: "A4", page_layout: :portrait, margin: 36) do |pdf|
      build_header(pdf)
      build_table(pdf)
    end.render
  end

  private

  attr_reader :clientes

  def normalize_collection(collection)
    return collection.except(:limit, :offset).load if collection.respond_to?(:except)

    Array(collection)
  end

  def build_header(pdf)
    pdf.text "Relatório de Clientes", size: 24, style: :bold, align: :center
    pdf.move_down 10
    pdf.text "Gerado em: #{I18n.l(Time.zone.now)}", size: 10, align: :right
    pdf.move_down 20
  end

  def build_table(pdf)
    if clientes.empty?
      pdf.text "Nenhum cliente cadastrado.", size: 12, style: :italic
      return
    end

    data = [ [ "Nome", "Email", "Telefone", "Endereço", "Data de nascimento" ] ]

    clientes.each do |cliente|
      data << [
        cliente.nome,
        cliente.email,
        cliente.telefone,
        cliente.endereco,
        cliente.data_nascimento.present? ? I18n.l(cliente.data_nascimento) : "—"
      ]
    end

    pdf.table(data, header: true, row_colors: %w[F8F9FA FFFFFF], cell_style: { size: 10 }) do
      row(0).font_style = :bold
      row(0).background_color = "343A40"
      row(0).text_color = "FFFFFF"
      cells.padding = 6
    end
  end
end
