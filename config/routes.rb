Rails.application.routes.draw do
  root 'contacts#new'
  resource :contact, only: [:create, :new, :show]
end
