class Emprestimo < ApplicationRecord
  belongs_to :cliente
  belongs_to :copia_filme

  scope :disponiveis, -> { where(status: 'Disponível') }

  def disponivel?
    status == 'Disponível'
  end
  
end
