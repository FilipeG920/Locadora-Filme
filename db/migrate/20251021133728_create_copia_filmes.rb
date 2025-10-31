class CreateCopiaFilmes < ActiveRecord::Migration[8.0]
  def change
    create_table :copia_filmes do |t|
      t.references :filme, null: false, foreign_key: true
      t.string :status
      t.string :tipo_midia

      t.timestamps
    end
  end
end
