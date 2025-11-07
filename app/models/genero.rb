class Genero < ApplicationRecord
  has_many :filmes, dependent: :destroy
end
