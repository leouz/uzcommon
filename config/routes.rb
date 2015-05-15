# -*- encoding : utf-8 -*-
Uzcommon::Engine.routes.draw do
  match '/admin' => 'Admin::sessions#new', as: :admin

  if Rails.env.development? or Rails.env.test?
    match '/bootstrap_test' => 'bootstrap_test#index'
  end

  namespace :admin do
    root :to => 'sessions#new'    

    match 'login' => 'sessions#create', as: :login
    match 'logout' => 'sessions#destroy', as: :logout

    match 'settings-group(/:key)' => 'settings#index', as: :settings_group
    match 'edit-setting/:group_key/:type/:key' => 'settings#edit', as: :edit_setting
    put 'update-setting' => 'settings#update', as: :update_setting

    post '/assets/summernote-upload' => 'assets#summernote_upload'
    post '/assets/destroy' => 'assets#destroy', :as => :assets_destroy
    get '/assets/get(/:group)' => 'assets#get', :as => :assets_get

    get '/dashboard' => 'dashboard#index',     as: :dashboard

    resources :assets, :only => [:index, :create]

    get     ':base_path/new'      => 'uzadmin#new',     as: :uzadmin_new
    post    ':base_path'          => 'uzadmin#create',  as: :uzadmin_create
    put     ':base_path/:id'      => 'uzadmin#update',  as: :uzadmin_update
    get     ':base_path'          => 'uzadmin#index',   as: :uzadmin_index
    get     ':base_path/:id/edit' => 'uzadmin#edit',    as: :uzadmin_edit
    get     ':base_path/:id/view' => 'uzadmin#view',    as: :uzadmin_view
    delete  ':base_path/:id'      => 'uzadmin#destroy', as: :uzadmin_destroy
    post    ':base_path/sort'     => 'uzadmin#sort',    as: :uzadmin_sort

    get     ':base_path/:base_id/:nested_path/new'             => 'uzadmin_nested#new',     as: :uzadmin_nested_new
    post    ':base_path/:base_id/:nested_path'                 => 'uzadmin_nested#create',  as: :uzadmin_nested_create
    put     ':base_path/:base_id/:nested_path/:nested_id'      => 'uzadmin_nested#update',  as: :uzadmin_nested_update
    get     ':base_path/:base_id/:nested_path'                 => 'uzadmin_nested#index',   as: :uzadmin_nested_index
    get     ':base_path/:base_id/:nested_path/:nested_id/edit' => 'uzadmin_nested#edit',    as: :uzadmin_nested_edit        
    get     ':base_path/:base_id/:nested_path/:nested_id/view' => 'uzadmin_nested#view',    as: :uzadmin_nested_view        
    delete  ':base_path/:base_id/:nested_path/:nested_id'      => 'uzadmin_nested#destroy', as: :uzadmin_nested_destroy
    post    ':base_path/:base_id/:nested_path/sort'            => 'uzadmin_nested#sort',    as: :uzadmin_nested_sort       

    get     ':base_path/:base_id/:nested_path/images/all'      => 'uzadmin_image_upload#all',      as: :uzadmin_nested_images_all
    post    ':base_path/:base_id/:nested_path/images/create'   => 'uzadmin_image_upload#create',   as: :uzadmin_nested_images_create
    post    ':base_path/:base_id/:nested_path/images/destroy'  => 'uzadmin_image_upload#destroy',  as: :uzadmin_nested_images_destroy
  end
end
