namespace :admin do
  desc "Cria ou atualiza o administrador padrão da locadora"
  task setup: :environment do
    # Lê variáveis de ambiente ou usa padrão
    email = ENV["ADMIN_EMAIL"] || "admin@locadora.com"
    password = ENV["ADMIN_PASSWORD"] || "123456"

    puts "➡️ Iniciando criação/atualização do admin..."
    puts "   Email: #{email}"

    admin = Admin.find_or_initialize_by(email: email)
    is_new = admin.new_record?

    admin.password = password
    admin.password_confirmation = password

    if admin.save
      action = is_new ? "criado" : "atualizado"
      puts "✅ Admin #{action} com sucesso!"
      puts "   Email: #{admin.email}"
      puts "   Senha: #{password}" if ENV["ADMIN_PASSWORD"].nil?
    else
      puts "❌ Falha ao criar/atualizar admin:"
      admin.errors.full_messages.each { |msg| puts "   - #{msg}" }
      exit 1
    end
  end
end
