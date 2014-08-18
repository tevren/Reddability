require 'sinatra/base'
require 'json'
require 'ruby_reddit_api'
require_relative 'lib/articleparser'
module Reddability
  class App < Sinatra::Base

    VERSION_FILE = File.join(settings.root, 'config', 'version.json')
    VERSION_INFO = File.file?(VERSION_FILE) ? JSON.parse(File.read(VERSION_FILE)) : {'version' => 'local'}

    before do
      cache_control :private, :no_cache, :no_store
      content_type  :html
    end

    get '/' do 
      r = Reddit::Api.new
      @articles = r.browse("", {:limit => 100, :section => "hot"})
      haml :index
    end

    get "/r/:subreddit" do 
      r = Reddit::Api.new
      @subreddit_id = params[:subreddit]
      @title = "Reddability::#{@subreddit_id}"
      @articles = r.browse(params[:subreddit], {:limit => 100, :section => "hot"})
      haml :index
    end

    get "/r/:subreddit/:id" do 
      parser =  ArticleParser.new(params[:id],{:tags => %w[div p img a], :attributes => %w[src href p], :remove_empty_nodes => true, :debug => true })
      @article = parser.run
      @title = "Reddability::#{@article.title}"
      @subreddit = params[:subreddit]
      haml :article
    end

    get '/ping' do 
      "PONG"
    end

    get '/status' do 
      content_type :json
      {status: 'ok'}.merge(VERSION_INFO).to_json
    end

  end
end