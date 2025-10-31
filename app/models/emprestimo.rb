class Emprestimo < ApplicationRecord
  belongs_to :cliente
  belongs_to :copia_filme
end
