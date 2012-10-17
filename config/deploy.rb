set :stages,%w(production)
set :default_stage, "production"
require 'capistrano/ext/multistage'
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'date'
#require "rvm/capistrano"       
set :repository,  "git://github.com/tevren/Reddability.git"
set :scm,:git
set :application, "Reddability"
set :git_enable_submodules, 1
set :deploy_via, :remote_cache

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`


set :branch do
  default_tag = `git tag`.split("\n").last

  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first): [#{default_tag}] "
  tag = default_tag if tag.empty?
  tag
end


namespace :deploy do
  desc "Add tag based on current version"
  task :auto_tag, :roles => :app do
    current_version = IO.read("VERSION").to_s.strip + Date.today.strftime("-%y%m%d")
    tag = Capistrano::CLI.ui.ask "Tag to add: [#{current_version}] "
    tag = current_version if tag.empty?

    system("git tag -a #{tag} -m 'auto-tagged' && git push origin --tags")
  end

  task :symlink_shared do
    run "ln -nfs #{deploy_to}shared/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}shared/app_config.yml #{release_path}/config/app_config.yml"
  end

end

desc "check production task"
task :check_production do 
	if stage.to_s == "production"
		puts "\n are you REALLY sure you want to deploy to production?"
		puts "\n Enter the password to continue\n"
		password = STDIN.gets[0..7] rescue nil
		if password != 'd0itwaterb0y'
			puts "\n !!! WRONG PASSWORD !!!"
			exit
		end
	end
end

before "deploy", "check_production"
after 'deploy:update_code', 'deploy:symlink_shared'

