require 'digest/sha1'
class RedditsController < ApplicationController
  caches_action :show, :expires_in => 3.minutes
  caches_action :subreddit, :expires_in => 1.minutes

  def index
    r = Reddit::Api.new
  	@articles = r.browse("", {:limit => 100, :section => "hot", :cookie => session[:cookie]})
    @subs = subs
      respond_to do |format|
        format.html
        format.xml {render xml: @articles}
      end
  end

  def saved
    r = Reddit::Api.new
    @saved_articles = r.saved({:limit => 100, :cookie => session[:cookie], :user => params[:user].to_s})
    @subs = subs
    respond_to do |format|
      format.html
      format.xml {render xml: @saved_articles}
    end
  end


  def show
    @original_url = Base64.urlsafe_decode64(params[:id]).to_s
    article = get_reddit_article(params[:article], params[:subreddit])
    if article.class.to_s.match(/array/i)
      @rarticle = article.first
    else
      @rarticle = article
    end
    @subreddit = params[:subreddit].to_s
    @submission_title = @rarticle.title
    @reddit_url = "http://reddit.com" + @rarticle.permalink
    @ckey = Digest::SHA1.hexdigest(params[:id])
    biffbot = Biffbot::Base.new(APP_CONFIG['DIFFBOT_TOKEN'])
    options = Hash.new
    options[:tags] = true
    options[:stats] = true
    options[:submission_title] = @submission_title
    @article = get_content_from_url(@original_url,options)
    logger.info "#{@article[:stats].to_s}" 
    @subs = subs
    respond_to do |format|
      format.html
      format.xml {render xml: @article}
    end
  end

  def subreddit
    r = Reddit::Api.new
  	@articles = r.browse("#{params[:id]}", {:limit => 100, :section => "hot",:cookie => session[:cookie]})
    @subreddit = params[:id]
    @subs = subs
    respond_to do |format|
      format.html
      format.xml {render xml: @articles}
    end
  end

  def get_content_from_url(url,options={})
    unless url.match(/(jpg|png|gif|jpeg|bmp|tiff)$/i)
      biffbot = Biffbot::Base.new(APP_CONFIG['DIFFBOT_TOKEN'])
      article = biffbot.parse(@original_url,options)
    else      
      article = Hash.new
      article[:text] = "<img src='#{url}'>"
      article[:title] = options[:submission_title] if options[:submission_title]
    end
    return article
  end

  def get_reddit_article(id,subreddit)
    r = Reddit::Api.new
    r.browse(subreddit, {:limit => 100, :section => "hot",:cookie => session[:cookie]}).each do |story|
      return story if story.id == id
    end
  end

end
