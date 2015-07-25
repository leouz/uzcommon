# -*- encoding : utf-8 -*-
Uzcommon::Engine.routes.draw do
  match '/admin' => 'Admin::sessions#new', as: :admin

  if Rails.env.development? or Rails.env.test?
    match '/bootstrap_test' => 'bootstrap_test#index'
  end
end
