# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'reader#show'

  resources :feeds, only: %i[index new create edit update destroy]
  resource :reader, only: :show, controller: 'reader'
end
