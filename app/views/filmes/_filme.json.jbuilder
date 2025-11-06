json.extract! filme, :id, :titulo, :sinopse, :ano_lancamento, :duracao, :genero_id, :created_at, :updated_at
json.url filme_url(filme, format: :json)
