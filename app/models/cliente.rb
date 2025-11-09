require "csv"

class Cliente < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :emprestimos, dependent: :destroy

  before_validation :normalize_telefone

  validates :nome, presence: true, length: { maximum: 150 }
  validates :telefone,
            presence: true,
            format: { with: /\A\+?\d{10,15}\z/, message: "deve conter entre 10 e 15 dígitos" }
  validates :endereco, presence: true, length: { maximum: 255 }
  validates :data_nascimento, presence: true
  validate :data_nascimento_no_passado

  def self.to_csv(collection = all)
    registros = normalize_collection(collection)

    CSV.generate(headers: true) do |csv|
      csv << ["Nome", "Email", "Telefone", "Endereço", "Data de nascimento"]

      registros.each do |cliente|
        csv << [
          cliente.nome,
          cliente.email,
          cliente.telefone,
          cliente.endereco,
          cliente.data_nascimento&.strftime("%Y-%m-%d")
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
          email = atributos.fetch("email") do
            raise ArgumentError, "coluna 'Email' é obrigatória"
          end

          cliente = find_or_initialize_by(email: email)
          cliente.nome = atributos["nome"].presence || cliente.nome
          cliente.telefone = atributos["telefone"].presence || cliente.telefone
          cliente.endereco = atributos["endereço"].presence || atributos["endereco"].presence || cliente.endereco

          data_nascimento_valor = atributos["data de nascimento"]
          if data_nascimento_valor.present?
            cliente.data_nascimento = parse_date(data_nascimento_valor)
          end

          unless cliente.save
            raise ActiveRecord::RecordInvalid, "Linha #{index + 2}: #{cliente.errors.full_messages.to_sentence}"
          end
        rescue ArgumentError => e
          raise ArgumentError, "Linha #{index + 2}: #{e.message}"
        end
      end
    end
  end

  private

  def self.normalize_collection(collection)
    return all.order(:nome).to_a if collection == all

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

  def self.parse_date(value)
    return if value.blank?

    Date.parse(value)
  rescue ArgumentError
    raise ArgumentError, "Data inválida: #{value}"
  end
  private_class_method :parse_date

  def normalize_telefone
    self.telefone = telefone.to_s.gsub(/\D/, "")
  end

  def data_nascimento_no_passado
    return if data_nascimento.blank?

    if data_nascimento > Date.current
      errors.add(:data_nascimento, "não pode estar no futuro")
    end
  end
end
