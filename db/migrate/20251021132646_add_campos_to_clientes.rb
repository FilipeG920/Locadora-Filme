class AddCamposToClientes < ActiveRecord::Migration[8.0]
  def change
    add_column :clientes, :nome, :string
    add_column :clientes, :telefone, :string
    add_column :clientes, :endereco, :string
    add_column :clientes, :data_nascimento, :date
  end
end
