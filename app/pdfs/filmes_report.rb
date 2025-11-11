class FilmesReport
  def initialize(filmes)
    @filmes = normalize_filmes(filmes)
  end

  def render
    Prawn::Document.new(page_size: "A4", page_layout: :portrait, margin: 36) do |pdf|
      build_header(pdf)
      build_table(pdf)
    end.render
  end

  private

  attr_reader :filmes

  def normalize_filmes(collection)
    return collection.except(:limit, :offset).load if collection.respond_to?(:except)

    Array(collection)
  end

  def build_header(pdf)
    pdf.text "Relatório de Filmes", size: 24, style: :bold, align: :center
    pdf.move_down 10
    pdf.text "Gerado em: #{I18n.l(Time.zone.now)}", size: 10, align: :right
    pdf.move_down 20
  end

  def build_table(pdf)
    if filmes.empty?
      pdf.text "Nenhum filme cadastrado.", size: 12, style: :italic
      return
    end

    filmes.each_with_index do |filme, index|
      pdf.text "#{index + 1}. #{filme.titulo}", size: 14, style: :bold
      pdf.indent(10) do
        pdf.text "Gênero: #{filme.genero&.nome || 'Sem gênero'}"
        pdf.text "Ano de lançamento: #{filme.ano_lancamento}"
        pdf.text "Duração: #{filme.duracao.present? ? "#{filme.duracao} min" : '—'}"
        pdf.text "Sinopse: #{filme.sinopse.presence || '—'}"
      end
      pdf.move_down 10
      pdf.stroke_horizontal_rule
      pdf.move_down 10
    end
  end
end
