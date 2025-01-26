Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      scope :admins do
        devise_for :admins,
          path: "", # This removes the /admins part from devise paths
          controllers: {
            sessions: "api/v1/admins/sessions",
            passwords: "api/v1/admins/passwords"
          }
      end

      resources :candidates, only: [ :index, :show, :create ]
      resources :invitations, only: [ :create ] do
        get :accept, on: :member
      end

      namespace :admins do
        get "dashboard", to: "dashboard#index"
        get "admins_list", to: "dashboard#admins_list"
        get "show_admin/:id", to: "dashboard#show_admin"
      end
    end
  end
end
