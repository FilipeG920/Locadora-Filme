class CopiaFilme < ApplicationRecord
  belongs_to :filme
  has_many :emprestimos, dependent: :destroy

  STATUS_OPTIONS = [
    "Disponível",
    "Alugado"
  ].freeze

  scope :disponiveis, -> { where(status: "Disponível") }

  validates :status,
            presence: true,
            inclusion: { in: STATUS_OPTIONS }
  validates :tipo_midia,
            presence: true,
            length: { maximum: 50 }

  def disponivel?
    status == "Disponível"
  end
end
