Rails.application.routes.draw do
  root :to => 'base#index'
  devise_for :users
  # devise_for :users, :controllers => { registrations: 'users/registrations', sessions: 'users/sessions' , passwords: 'users/passwords', two_factor_authentication: 'users/two_factor_authentication', unlocks: 'users/unlocks',password_expired: 'users/password_expired'}

  devise_scope :user do
    authenticated :user do
      root 'base#index', as: :authenticated_root
    end

    # unauthenticated do
    #   root 'devise/sessions#new', as: :unauthenticated_root
    # end
    post "sign_up", to: "registrations#create"
    post "sign_in", to: "sessions#create"

    resources :papers  do
      collection do
        get :questions
        get :solve_paper
        get :view_questions
        post :submit_paper
        resources :students do
          collection do
            get :questions
            get :solve_paper
            post :submit_paper
            get :student_paper
            get :view_paper
          end
        end
      end
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
