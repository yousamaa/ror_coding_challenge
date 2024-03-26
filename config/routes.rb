Rails.application.routes.draw do
  namespace :api do
    resources :products, only: [:index, :create, :update, :destroy] do
      collection do
        get 'search'
      end
    end
    get '/products/approval-queue', to: 'products#approval_queue'
    put '/products/approval-queue/:approval_id/approve', to: 'products#approve'
    put '/products/approval-queue/:approval_id/reject', to: 'products#reject'
  end
end
