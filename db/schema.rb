# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_06_213037) do
  create_table "admins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "clientes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.string "telefone"
    t.string "endereco"
    t.date "data_nascimento"
    t.index ["email"], name: "index_clientes_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clientes_on_reset_password_token", unique: true
  end

  create_table "copia_filmes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "filme_id", null: false
    t.string "status"
    t.string "tipo_midia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filme_id"], name: "index_copia_filmes_on_filme_id"
  end

  create_table "emprestimos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "cliente_id", null: false
    t.bigint "copia_filme_id", null: false
    t.datetime "data_emprestimo"
    t.datetime "data_prevista_devolucao"
    t.datetime "data_devolucao_efetiva"
    t.decimal "valor_locacao", precision: 10
    t.decimal "valor_multa", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_emprestimos_on_cliente_id"
    t.index ["copia_filme_id"], name: "index_emprestimos_on_copia_filme_id"
  end

  create_table "filmes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "titulo"
    t.text "sinopse"
    t.integer "ano_lancamento"
    t.integer "duracao"
    t.bigint "genero_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genero_id"], name: "index_filmes_on_genero_id"
  end

  create_table "generos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "copia_filmes", "filmes"
  add_foreign_key "emprestimos", "clientes"
  add_foreign_key "emprestimos", "copia_filmes"
  add_foreign_key "filmes", "generos"
end
