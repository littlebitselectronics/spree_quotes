Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :quotes
  end

  resources :quotes
end
