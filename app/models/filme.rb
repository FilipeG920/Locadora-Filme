class Filme < ApplicationRecord
  belongs_to :genero
  has_many :copia_filmes
end
