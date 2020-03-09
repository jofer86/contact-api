# frozen_string_literal: true

Rails.application.routes.draw do
  resources :contacts, only: [:index, :show, :create]
end
