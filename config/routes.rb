Rails.application.routes.draw do
  resources :urls, only: %i[new create show], param: :token
  get ':token', to: 'urls#visit', as: :visit

  root to: 'urls#new'
end
