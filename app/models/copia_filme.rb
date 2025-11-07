class CopiaFilme < ApplicationRecord
  belongs_to :filme
  has_many :emprestimos, dependent: :destroy
end
