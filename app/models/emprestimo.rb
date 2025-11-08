class Emprestimo < ApplicationRecord
  belongs_to :cliente
  belongs_to :copia_filme

  scope :disponiveis, -> { where(status: "Disponível") }

  validates :data_emprestimo, presence: true
  validates :data_prevista_devolucao, presence: true
  validates :valor_locacao,
            presence: true,
            numericality: { greater_than: 0 }
  validates :valor_multa,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true
  validate :datas_validas

  def disponivel?
    status == "Disponível"
  end

  private

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
