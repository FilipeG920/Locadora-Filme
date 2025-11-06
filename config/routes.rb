Rails.application.routes.draw do
  get "home/index"
  devise_for :controllers
  resources :emprestimos
  resources :copia_filmes
  resources :filmes
  resources :generos
  devise_for :clientes, controllers: {
    registrations: 'clientes/registrations',
    sessions: 'clientes/sessions'
  }
  resources :emprestimos do
    member do
      patch :devolver
    end
  end

  resources :emprestimos
  resources :clientes do 
    resources :emprestimos
  end

  resources :copia_filmes do
    resources :emprestimos
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_scope :cliente do
    root to: "devise/registrations#new"
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
