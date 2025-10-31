class CreateFilmes < ActiveRecord::Migration[8.0]
  def change
    create_table :filmes do |t|
      t.string :titulo
      t.text :sinopse
      t.integer :ano_lancamento
      t.integer :duracao
      t.references :genero, null: false, foreign_key: true

      t.timestamps
    end
  end
end
