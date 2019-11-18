Rails.application.routes.draw do
    
  devise_for :users, controllers: { invitations: "users/invitations" },
             path_names:  { sign_in: "login", sign_out: "logout" }
                       
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
  
    authenticated :user do
      root to: "home#index", as: :authenticated_user_root
    end
  
    unauthenticated do
      root to: "home#index"
    end
  
    resources :pledges,        only: [ :index, :create, :show ]
    get '/pledge',             to: 'pledges#new',    as: :new_pledge
    get '/take-the-pledge',    to: 'pledges#new'
    get '/glhf',               to: 'pledges#new',    as: :glhf
    get 'referral-lookup',     to: 'pledges#referral_lookup', as: :referral_lookup
    post 'referral-send',      to: 'pledges#referral_send', as: :referral_send
    resources :affiliates,     only: [ :index, :new, :create, :edit, :update ]
    resources :resources,      only: [ :index ]
    get '/research',           to: 'resources#index',          as: :research
    get '/keystone-code',      to: 'resources#keystone_code',  as: :keystone_code    
    resources :stories,        only: [ :index, :new, :create, :edit, :update ]
    resources :reports,        only: [ :index, :show, :new, :create ] do
      member do
        post :dismiss
        post :undismiss
      end
      resources :warnings,     only: [ :new, :create ]
      resources :revocations,  only: [ :new, :create ]
    end
    get '/report',             to: 'reports#new',        as: :short_report

    resources :staff,          only: [ :index ]
    resources :users,          only: [ :index, :edit, :update ]
    post '/users/:id/remove_avatar', to: 'users#remove_avatar', as: :remove_avatar
    
    get '/about',              to: 'about#index',        as: :about
    get '/contact',            to: 'about#contact',      as: :contact
    get '/data-policy',        to: 'about#data_policy',  as: :data_policy
    
  end
    
end
