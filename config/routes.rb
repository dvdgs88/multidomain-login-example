# frozen_string_literal: true

Rails.application.routes.draw do

  root 'sessions#index'

  post 'session', controller: :sessions, action: :create
  delete 'session', controller: :sessions, action: :destroy

  namespace :api do
    namespace :v1 do
      get 'login', controller: :logins, action: :create
      get 'logout', controller: :logouts, action: :create
    end
  end
end
