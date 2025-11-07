Rails.application.routes.draw do
  # ========== ÁREA ADMINISTRATIVA ==========
  devise_for :admins
  namespace :admin do
    get "dashboard/index"
    resources :filmes
    resources :generos
    root to: "dashboard#index"
  end


  # ========== ÁREA PÚBLICA (CLIENTES) ==========
  devise_for :clientes, controllers: {
    registrations: "clientes/registrations",
    sessions: "clientes/sessions"
  }

  get "home/index"

  # Recursos principais da área do cliente
  resources :filmes, only: [ :index, :show ]
  resources :generos, only: [ :index, :show ]
  resources :copia_filmes, only: [ :index, :show ]

  # Empréstimos — inclui rota para devolver
  resources :emprestimos do
    member do
      patch :devolver
    end
  end

  resources :copia_filmes do
    resources :emprestimos
  end

  # ========== ROOT ==========
  root "home#index"

  # ========== Healthcheck ==========
  get "up" => "rails/health#show", as: :rails_health_check
end
