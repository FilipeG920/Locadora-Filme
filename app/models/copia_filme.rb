class CopiaFilme < ApplicationRecord
  belongs_to :filme
  has_many :emprestimos
end
