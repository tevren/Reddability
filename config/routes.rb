Reddability::Application.routes.draw do
  resources :reddits, :id => /.+/, :subreddit => /.+/
  get "login" => "sessions#new", :as => :login
  get "logout" => "sessions#destroy", :as => :logout
  get "saved/:user" => "reddits#saved", :user => %r([^/;,?]+), :as => :saved
  get "/:subreddit/:id" => "reddits#show", :subreddit => %r([^/;,?]+), :as => :show_article
  get "/:id" => "reddits#subreddit",  :id => %r([^/;,?]+), :as => :get_subreddit
  resources :sessions
  root :to =>'reddits#index'
end
