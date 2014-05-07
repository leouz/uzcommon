# -*- encoding : utf-8 -*-
Uzcommon::Engine.routes.draw do
  # get "errors/error_404"
  # get "errors/error_500"

  # root :to => 'home#index'
    
  # match '/admin' => 'Admin::sessions#new', :as => :admin
  # namespace :admin do    
  #   root :to => 'sessions#new'

  #   match 'login' => 'sessions#create', :as => :login
  #   match 'logout' => 'sessions#destroy', :as => :logout

  #   match 'settings-group(/:key)' => 'settings#index', :as => :settings_group
  #   match 'edit-setting/:group_key/:type/:key' => 'settings#edit', :as => :edit_setting
  #   put 'update-setting' => 'settings#update', :as => :update_setting

  #   post '/assets/summernote-upload' => 'assets#summernote_upload'
  #   post '/assets/destroy' => 'assets#destroy', :as => :assets_destroy
  #   get '/assets/get(/:group)' => 'assets#get', :as => :assets_get

  #   resources :assets, :only => [:index, :create] do
  #   end
  #   resources :posts, :except => :show
  #   resources :events, :except => :show
  #   resources :artists, :except => :show 
  # end
  

  # match '/about-us' => "home#about_us", :as => :home_about_us
  # match '/management' => "home#management", :as => :home_management
  # match '/marketing' => "home#marketing", :as => :home_marketing
  # match '/events' => "home#events", :as => :home_events  
  # match '/contact' => "home#contact", :as => :home_contact
  # match '/events/:permalink' => "home#event_detail", :as => :home_event_detail
  # match '/posts/:permalink' => "home#post", :as => :home_post
  # match '/posts/tag/:tag' => "home#tag", :as => :home_tag
  # match '/artist/:permalink' => "home#artist", :as => :home_artist
end
