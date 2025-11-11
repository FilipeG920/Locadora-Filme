# frozen_string_literal: true

# Para executar este script utilize: bin/rails db:seed

require 'bigdecimal'

# Admin padrão para primeiro acesso
admin_email = 'admin@locadora.com'
admin_password = 'Locadora@123'
admin = Admin.find_or_initialize_by(email: admin_email)
admin.password = admin_password
admin.password_confirmation = admin_password
admin.save!

# Gêneros e filmes relacionados
catalogo_por_genero = {
  'Ação' => [
    {
      titulo: 'Velocidade Extrema',
      sinopse: 'Um piloto habilidoso precisa liderar uma equipe improvável para impedir um crime internacional.',
      ano_lancamento: 2015,
      duracao: 128
    },
    {
      titulo: 'Operação Resgate',
      sinopse: 'Uma missão de resgate em território hostil transforma-se em uma corrida contra o tempo.',
      ano_lancamento: 2018,
      duracao: 114
    }
  ],
  'Comédia' => [
    {
      titulo: 'Risos Garantidos',
      sinopse: 'Dois amigos de infância decidem abrir um clube de comédia e enfrentam situações hilárias.',
      ano_lancamento: 2020,
      duracao: 102
    },
    {
      titulo: 'Confusão em Família',
      sinopse: 'Reunião familiar vira caos quando um segredo antigo vem à tona em pleno jantar.',
      ano_lancamento: 2017,
      duracao: 97
    }
  ],
  'Drama' => [
    {
      titulo: 'Amor em Foco',
      sinopse: 'Uma fotógrafa encontra inspiração ao documentar a vida de um bairro prestes a desaparecer.',
      ano_lancamento: 2019,
      duracao: 118
    },
    {
      titulo: 'Horizonte Perdido',
      sinopse: 'Após uma tragédia, um professor tenta reconstruir a própria vida e a confiança da família.',
      ano_lancamento: 2016,
      duracao: 121
    }
  ]
}

generos = catalogo_por_genero.keys.each_with_object({}) do |nome_genero, hash|
  hash[nome_genero] = Genero.find_or_create_by!(nome: nome_genero)
end

filmes = {}

catalogo_por_genero.each do |nome_genero, filmes_attrs|
  genero = generos.fetch(nome_genero)

  filmes_attrs.each do |filme_attrs|
    filme = Filme.find_or_initialize_by(titulo: filme_attrs[:titulo])
    filme.sinopse = filme_attrs[:sinopse]
    filme.ano_lancamento = filme_attrs[:ano_lancamento]
    filme.duracao = filme_attrs[:duracao]
    filme.genero = genero
    filme.save!

    filmes[filme.titulo] = filme

    copia_disponivel = CopiaFilme.find_or_initialize_by(filme: filme, tipo_midia: 'Blu-Ray')
    copia_disponivel.status = 'Disponível'
    copia_disponivel.save!
  end
end

# Clientes de teste
clientes_attrs = [
  {
    email: 'ana.silva@exemplo.com',
    nome: 'Ana Silva',
    telefone: '11987654321',
    endereco: 'Rua das Flores, 123, São Paulo - SP',
    data_nascimento: Date.new(1990, 5, 20),
    password: 'Senha@123'
  },
  {
    email: 'bruno.lima@exemplo.com',
    nome: 'Bruno Lima',
    telefone: '21999887766',
    endereco: 'Avenida Atlântica, 987, Rio de Janeiro - RJ',
    data_nascimento: Date.new(1985, 9, 12),
    password: 'Senha@123'
  },
  {
    email: 'carla.souza@exemplo.com',
    nome: 'Carla Souza',
    telefone: '31988776655',
    endereco: 'Rua da Liberdade, 45, Belo Horizonte - MG',
    data_nascimento: Date.new(1992, 2, 8),
    password: 'Senha@123'
  }
]

clientes = clientes_attrs.each_with_object({}) do |attrs, hash|
  cliente = Cliente.find_or_initialize_by(email: attrs[:email])
  cliente.nome = attrs[:nome]
  cliente.telefone = attrs[:telefone]
  cliente.endereco = attrs[:endereco]
  cliente.data_nascimento = attrs[:data_nascimento]
  cliente.password = attrs[:password]
  cliente.password_confirmation = attrs[:password]
  cliente.save!
  hash[cliente.email] = cliente
end

# Empréstimos de teste
emprestimos_attrs = [
  {
    cliente_email: 'ana.silva@exemplo.com',
    filme_titulo: 'Velocidade Extrema',
    tipo_midia: 'DVD',
    data_emprestimo: Time.zone.local(2024, 1, 10, 10, 0, 0),
    data_prevista_devolucao: Time.zone.local(2024, 1, 17, 10, 0, 0),
    data_devolucao_efetiva: nil,
    valor_locacao: BigDecimal('12.90'),
    valor_multa: nil
  },
  {
    cliente_email: 'bruno.lima@exemplo.com',
    filme_titulo: 'Risos Garantidos',
    tipo_midia: 'Digital HD',
    data_emprestimo: Time.zone.local(2023, 12, 5, 18, 0, 0),
    data_prevista_devolucao: Time.zone.local(2023, 12, 12, 18, 0, 0),
    data_devolucao_efetiva: Time.zone.local(2023, 12, 11, 17, 0, 0),
    valor_locacao: BigDecimal('9.50'),
    valor_multa: BigDecimal('0.0')
  }
]

emprestimos_attrs.each do |attrs|
  cliente = clientes.fetch(attrs[:cliente_email])
  filme = filmes.fetch(attrs[:filme_titulo])

  copia = CopiaFilme.find_or_initialize_by(filme: filme, tipo_midia: attrs[:tipo_midia])
  if attrs[:data_devolucao_efetiva].nil?
    copia.status = 'Alugado'
  else
    copia.status = 'Disponível'
  end
  copia.save!

  emprestimo = Emprestimo.find_or_initialize_by(
    cliente: cliente,
    copia_filme: copia,
    data_emprestimo: attrs[:data_emprestimo]
  )
  emprestimo.data_prevista_devolucao = attrs[:data_prevista_devolucao]
  emprestimo.data_devolucao_efetiva = attrs[:data_devolucao_efetiva]
  emprestimo.valor_locacao = attrs[:valor_locacao]
  emprestimo.valor_multa = attrs[:valor_multa]
  emprestimo.save!

  if emprestimo.data_devolucao_efetiva.nil?
    copia.update!(status: 'Alugado')
  else
    copia.update!(status: 'Disponível')
  end
end
