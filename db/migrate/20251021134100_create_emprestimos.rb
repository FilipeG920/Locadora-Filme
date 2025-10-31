class CreateEmprestimos < ActiveRecord::Migration[8.0]
  def change
    create_table :emprestimos do |t|
      t.references :cliente, null: false, foreign_key: true
      t.references :copia_filme, null: false, foreign_key: true
      t.datetime :data_emprestimo
      t.datetime :data_prevista_devolucao
      t.datetime :data_devolucao_efetiva
      t.decimal :valor_locacao
      t.decimal :valor_multa

      t.timestamps
    end
  end
end
