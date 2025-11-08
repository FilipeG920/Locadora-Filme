require "csv"

class Genero < ApplicationRecord
  has_many :filmes, dependent: :destroy

  before_validation :normalize_nome

  validates :nome,
            presence: true,
            length: { maximum: 100 },
            uniqueness: { case_sensitive: false }

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << [ "nome", "total_filmes", "atualizado_em" ]

      includes(:filmes).order(:nome).find_each do |genero|
        csv << [
          genero.nome,
          genero.filmes.size,
          genero.updated_at&.iso8601
        ]
      end
    end
  end

  def self.import_from_csv(file)
    result = { created: 0, updated: 0, errors: [] }
    return result.merge(errors: [ "Arquivo CSV inválido ou não informado." ]) unless file.respond_to?(:path)

    CSV.foreach(file.path, headers: true, encoding: "bom|utf-8").with_index(2) do |row, line_number|
      next if row.to_h.values.all?(&:blank?)

      nome = row["nome"].to_s.strip

      if nome.blank?
        result[:errors] << "Linha #{line_number}: nome é obrigatório."
        next
      end

      genero = Genero.find_or_initialize_by(nome: nome)
      created = genero.new_record?

      if genero.save
        result[created ? :created : :updated] += 1
      else
        result[:errors] << "Linha #{line_number}: #{genero.errors.full_messages.to_sentence}."
      end
    rescue StandardError => e
      result[:errors] << "Linha #{line_number}: #{e.message}."
    end

    result
  end

  private

  def normalize_nome
    self.nome = nome.to_s.strip
  end
end
