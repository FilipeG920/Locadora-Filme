require "csv"

class Filme < ApplicationRecord
  belongs_to :genero
  has_many :copia_filmes, dependent: :destroy

  MIN_RELEASE_YEAR = 1895
  MAX_FUTURE_OFFSET = 1

  before_validation :normalize_attributes

  validates :titulo,
            presence: true,
            length: { maximum: 150 },
            uniqueness: { scope: :ano_lancamento, case_sensitive: false }
  validates :sinopse, length: { maximum: 1000 }, allow_blank: true
  validates :ano_lancamento,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: MIN_RELEASE_YEAR,
              less_than_or_equal_to: ->(_) { Date.current.year + MAX_FUTURE_OFFSET }
            }
  validates :duracao,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << [
        "titulo",
        "sinopse",
        "ano_lancamento",
        "duracao",
        "genero"
      ]

      includes(:genero).find_each do |filme|
        csv << [
          filme.titulo,
          filme.sinopse,
          filme.ano_lancamento,
          filme.duracao,
          filme.genero&.nome
        ]
      end
    end
  end

  def self.import_from_csv(file)
    result = { created: 0, updated: 0, errors: [] }
    return result.merge(errors: [ "Arquivo CSV inválido ou não informado." ]) unless file.respond_to?(:path)

    CSV.foreach(file.path, headers: true, encoding: "bom|utf-8").with_index(2) do |row, line_number|
      next if row.to_h.values.all?(&:blank?)

      titulo        = row["titulo"].to_s.strip
      sinopse       = row["sinopse"].to_s.strip.presence
      ano_lancamento = row["ano_lancamento"].presence && row["ano_lancamento"].to_i
      duracao       = row["duracao"].presence && row["duracao"].to_i
      genero_nome   = row["genero"].presence || row["genero_nome"].presence

      if titulo.blank? || genero_nome.blank?
        result[:errors] << "Linha #{line_number}: título e gênero são obrigatórios."
        next
      end

      genero = Genero.find_or_create_by(nome: genero_nome.strip)
      filme  = Filme.find_or_initialize_by(titulo: titulo, ano_lancamento: ano_lancamento)
      created = filme.new_record?
      filme.assign_attributes(
        sinopse: sinopse,
        duracao: duracao,
        genero: genero
      )

      if filme.save
        result[created ? :created : :updated] += 1
      else
        result[:errors] << "Linha #{line_number}: #{filme.errors.full_messages.to_sentence}."
      end
    rescue StandardError => e
      result[:errors] << "Linha #{line_number}: #{e.message}."
    end

    result
  end

  private

  def normalize_attributes
    self.titulo = titulo.to_s.strip
    self.sinopse = sinopse.to_s.strip.presence
  end
end
