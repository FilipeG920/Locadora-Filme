require "prawn/table"

class EmprestimosReport
  include ActionView::Helpers::NumberHelper

  def initialize(emprestimos)
    @emprestimos = normalize_collection(emprestimos)
  end

  def render
    Prawn::Document.new(page_size: "A4", page_layout: :landscape, margin: 36) do |pdf|
      build_header(pdf)
      build_table(pdf)
    end.render
  end

  private

  attr_reader :emprestimos

  def normalize_collection(collection)
    return collection.except(:limit, :offset).load if collection.respond_to?(:except)

    Array(collection)
  end

  def build_header(pdf)
    pdf.text "Relatório de Empréstimos", size: 24, style: :bold, align: :center
    pdf.move_down 10
    pdf.text "Gerado em: #{I18n.l(Time.zone.now)}", size: 10, align: :right
    pdf.move_down 20
  end

  def build_table(pdf)
    if emprestimos.empty?
      pdf.text "Nenhum empréstimo encontrado.", size: 12, style: :italic
      return
    end

    data = [ [ "Cliente", "Filme", "Dias", "Valor total", "Valor multa", "Status", "Previsto", "Devolução" ] ]

    emprestimos.each do |emprestimo|
      dias = if emprestimo.data_emprestimo.present? && emprestimo.data_prevista_devolucao.present?
               (emprestimo.data_prevista_devolucao.to_date - emprestimo.data_emprestimo.to_date).to_i
      end

      data << [
        emprestimo.cliente&.nome || emprestimo.cliente&.email,
        emprestimo.copia_filme&.filme&.titulo,
        dias,
        number_to_currency(emprestimo.valor_locacao),
        emprestimo.valor_multa.present? ? number_to_currency(emprestimo.valor_multa) : "—",
        emprestimo.data_devolucao_efetiva.present? ? "Devolvido" : "Em aberto",
        emprestimo.data_prevista_devolucao.present? ? I18n.l(emprestimo.data_prevista_devolucao.to_date) : "—",
        emprestimo.data_devolucao_efetiva.present? ? I18n.l(emprestimo.data_devolucao_efetiva.to_date) : "—"
      ]
    end

    pdf.table(data, header: true, row_colors: %w[F8F9FA FFFFFF], cell_style: { size: 9 }) do
      row(0).font_style = :bold
      row(0).background_color = "1D3557"
      row(0).text_color = "FFFFFF"
      cells.padding = 6
      columns(2..4).align = :right
    end
  end
end
