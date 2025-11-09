require "csv"
require "bigdecimal/util"

class Emprestimo < ApplicationRecord
  belongs_to :cliente
  belongs_to :copia_filme

  validates :data_emprestimo, presence: true
  validates :data_prevista_devolucao, presence: true
  validates :valor_locacao,
            presence: true,
            numericality: { greater_than: 0 }
  validates :valor_multa,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true
  validate :datas_validas

  def self.to_csv(collection = all)
    registros = normalize_collection(collection)

    CSV.generate(headers: true) do |csv|
      csv << ["Cliente (email)", "Filme", "Dias", "Valor total", "Valor multa", "Status"]

      registros.each do |emprestimo|
        dias = if emprestimo.data_emprestimo.present? && emprestimo.data_prevista_devolucao.present?
                 ((emprestimo.data_prevista_devolucao.to_date - emprestimo.data_emprestimo.to_date).to_i)
               end

        csv << [
          emprestimo.cliente&.email,
          emprestimo.copia_filme&.filme&.titulo,
          dias,
          emprestimo.valor_locacao,
          emprestimo.valor_multa,
          emprestimo.data_devolucao_efetiva.present? ? "Devolvido" : "Em aberto"
        ]
      end
    end
  end

  def self.import_from_csv(file)
    raise ArgumentError, "Arquivo CSV não informado" if file.blank?

    csv_content = file.respond_to?(:read) ? file.read : File.read(file)
    file.rewind if file.respond_to?(:rewind)

    linhas = CSV.parse(csv_content, headers: true)

    transaction do
      linhas.each_with_index do |row, index|
        atributos = normalize_headers(row)
        next if atributos.values.all?(&:blank?)

        begin
          email_cliente = atributos["cliente"] || atributos["cliente (email)"] || atributos["cliente email"]
          raise ArgumentError, "coluna 'Cliente (email)' é obrigatória" if email_cliente.blank?

          filme_titulo = atributos["filme"]
          raise ArgumentError, "coluna 'Filme' é obrigatória" if filme_titulo.blank?

          cliente = Cliente.find_by(email: email_cliente)
          raise ActiveRecord::RecordNotFound, "cliente #{email_cliente} não encontrado" if cliente.nil?

          filme = Filme.find_by(titulo: filme_titulo)
          raise ActiveRecord::RecordNotFound, "filme '#{filme_titulo}' não encontrado" if filme.nil?

          copia = filme.copia_filmes.disponiveis.first || filme.copia_filmes.first
          raise ActiveRecord::RecordNotFound, "nenhuma cópia cadastrada para '#{filme_titulo}'" if copia.nil?

          dias = parse_days(atributos["dias"])
          valor_total = parse_decimal(atributos["valor total"])
          valor_multa = parse_decimal(atributos["valor multa"]) if atributos.key?("valor multa")

          data_inicio = Time.zone.now
          data_prevista = dias.positive? ? data_inicio + dias.days : data_inicio

          emprestimo = new(
            cliente: cliente,
            copia_filme: copia,
            data_emprestimo: data_inicio,
            data_prevista_devolucao: data_prevista,
            valor_locacao: valor_total,
            valor_multa: valor_multa
          )

          unless emprestimo.save
            raise ActiveRecord::RecordInvalid, emprestimo.errors.full_messages.to_sentence
          end

          if copia.respond_to?(:status) && copia.disponivel?
            copia.update!(status: "Alugado")
          end
        rescue ArgumentError, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
          raise e.class, "Linha #{index + 2}: #{e.message}"
        end
      end
    end
  end

  private

  def self.normalize_collection(collection)
    return all.order(data_emprestimo: :desc).to_a if collection == all

    if collection.respond_to?(:to_a)
      collection.to_a
    else
      Array(collection)
    end
  end
  private_class_method :normalize_collection

  def self.normalize_headers(row)
    row.to_h.each_with_object({}) do |(key, value), hash|
      normalized_key = key.to_s.strip.downcase
      hash[normalized_key] = value.to_s.strip
    end
  end
  private_class_method :normalize_headers

  def self.parse_decimal(value)
    return if value.blank?

    raw = value.to_s.strip
    normalized = if raw.include?(",") && raw.include?(".")
                   raw.delete(".").tr(",", ".")
                 elsif raw.include?(",")
                   raw.tr(",", ".")
                 else
                   raw
                 end

    normalized.to_d
  rescue ArgumentError
    raise ArgumentError, "Valor numérico inválido: #{value}"
  end
  private_class_method :parse_decimal

  def self.parse_days(value)
    return 0 if value.blank?

    Integer(value)
  rescue ArgumentError
    raise ArgumentError, "Quantidade de dias inválida: #{value}"
  end
  private_class_method :parse_days

  def datas_validas
    return if data_emprestimo.blank?

    if data_prevista_devolucao.present? && data_prevista_devolucao < data_emprestimo
      errors.add(:data_prevista_devolucao, "não pode ser anterior à data do empréstimo")
    end

    if data_devolucao_efetiva.present? && data_devolucao_efetiva < data_emprestimo
      errors.add(:data_devolucao_efetiva, "não pode ser anterior à data do empréstimo")
    end
  end
end
