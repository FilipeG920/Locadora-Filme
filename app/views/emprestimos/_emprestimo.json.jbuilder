json.extract! emprestimo, :id, :cliente_id, :copia_filme_id, :data_emprestimo, :data_prevista_devolucao, :data_devolucao_efetiva, :valor_locacao, :valor_multa, :created_at, :updated_at
json.url emprestimo_url(emprestimo, format: :json)
