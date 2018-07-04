Rails.application.routes.draw do
  get 'welcome/index' 
  post 'welcome/index' 
  root 'welcome#index'
end
