# Locadora de Filmes

## Visão Geral
A Locadora de Filmes é uma aplicação web desenvolvida em Ruby on Rails que permite cadastrar títulos, gerenciar exemplares físicos (DVD, Blu-ray) e controlar o ciclo completo de locação dos clientes. Ela oferece uma interface administrativa para manter o catálogo de filmes, acompanhar empréstimos/devoluções e administrar usuários internos.

## Funcionalidades Principais
- Cadastro e gerenciamento de filmes com diferentes gêneros, formatos e mídias.
- Controle de disponibilidade dos exemplares para locação.
- Registro de clientes e acompanhamento do histórico de locações.
- Painel administrativo protegido por autenticação com gerenciamento de usuários.
- Seeds pré-configuradas para criação de um usuário administrador padrão.

## Requisitos
Certifique-se de possuir os seguintes softwares instalados:
- **Ruby 3.2.3** – utilize um gerenciador como `rbenv` ou `rvm` para instalar a versão correta.
- **Bundler** – para gerenciar as gems do projeto (`gem install bundler`).
- **MySQL** – banco de dados relacional utilizado pela aplicação.
- **Node.js** e **Yarn** – necessários para compilar assets JavaScript/CSS caso ainda não estejam disponíveis em seu ambiente Rails.

## Clonando o Repositório
```bash
git clone https://github.com/<seu-usuario>/Locadora-Filme.git
cd Locadora-Filme
```

## Instalação de Dependências
Instale as gems Ruby necessárias:
```bash
bundle install
```
Caso o projeto possua dependências front-end, utilize o Yarn para instalá-las:
```bash
yarn install
```

## Configuração do Banco de Dados
1. Copie o arquivo de exemplo ou edite `config/database.yml` para refletir suas credenciais locais.
2. Crie um usuário MySQL com permissões de leitura/escrita no banco configurado e ajuste `username`/`password` conforme necessário.
3. Verifique se o serviço MySQL está em execução antes de prosseguir.

## Preparando o Banco de Dados
Execute os comandos abaixo para criar, migrar e popular o banco:
```bash
bin/rails db:create       # cria o banco de dados configurado
bin/rails db:migrate      # aplica as migrations e estrutura o schema
bin/rails db:seed         # insere dados iniciais, incluindo o admin padrão
```
Alternativamente, você pode usar um único comando que executa as três etapas acima em sequência:
```bash
bin/rails db:prepare
```

## Executando a Aplicação
Inicie o servidor de desenvolvimento local:
```bash
bin/dev
```
Caso não utilize o setup com `foreman`/`overmind`, é possível iniciar apenas o servidor Rails:
```bash
bin/rails server
```
Após iniciar, acesse `http://localhost:3000`. Os seeds criam um administrador padrão com as credenciais:
- **E-mail:** `admin@locadora.com`
- **Senha:** `Locadora@123`

## Testes Automatizados
Para executar a suíte de testes Rails, utilize:
```bash
bin/rails test
```

## Recursos Adicionais
- O script `bin/setup` realiza o fluxo completo de configuração inicial automaticamente.
- Confira os arquivos na pasta `docker/` (se disponíveis) e o `Dockerfile` para alternativas de execução containerizada.
- Consulte a documentação oficial do Rails em <https://guides.rubyonrails.org/> para aprofundar-se nas ferramentas utilizadas.
