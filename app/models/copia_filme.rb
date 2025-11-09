class CopiaFilme < ApplicationRecord
  belongs_to :filme
  has_many :emprestimos, dependent: :destroy

  STATUS_OPTIONS = [
    "Disponível",
    "Alugado"
  ].freeze

  scope :disponiveis, -> { where(status: "Disponível") }
  scope :disponiveis_para_aluguel, lambda {
    where(status: "Disponível")
      .where.not(id: Emprestimo.where(data_devolucao_efetiva: nil).select(:copia_filme_id))
  }

  validates :status,
            presence: true,
            inclusion: { in: STATUS_OPTIONS }
  validates :tipo_midia,
            presence: true,
            length: { maximum: 50 }

  def disponivel?
    status == "Disponível"
  end

  def emprestimo_ativo?
    emprestimos.exists?(data_devolucao_efetiva: nil)
  end

  def disponivel_para_aluguel?
    disponivel? && !emprestimo_ativo?
  end

  def marcar_como_alugada!
    update!(status: "Alugado")
  end

  def marcar_como_disponivel!
    update!(status: "Disponível")
  end
end
