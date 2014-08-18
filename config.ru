require 'rubygems'
require 'sass'
require 'sprockets'
require './application'

map '/assets' do
  foundation_path = Bundler.load.specs.select{|g| g.name=="zurb-foundation-5"}.first.full_gem_path
  jquery_path = Bundler.load.specs.select{|g| g.name=="jquery-rails"}.first.full_gem_path
  fastclick_path = Bundler.load.specs.select{|g| g.name=="fastclick-rails"}.first.full_gem_path
  modernizr_path = Bundler.load.specs.select{|g| g.name=="modernizr-rails"}.first.full_gem_path
  
  environment = Sprockets::Environment.new  
  environment.cache = Sprockets::Cache::FileStore.new("/tmp")
  environment.append_path 'assets/js'
  environment.append_path 'assets/images'
  environment.append_path 'assets/scss'
  environment.append_path "#{foundation_path}/js/foundation"
  environment.append_path "#{foundation_path}/scss"
  environment.append_path "#{jquery_path}/vendor/assets/javascripts"
  environment.append_path "#{fastclick_path}/vendor/assets/javascripts"
  environment.append_path "#{modernizr_path}/vendor/assets/javascripts"
  run environment
end

run Reddability::App


