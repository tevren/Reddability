class RedditsController < ApplicationController
  before_filter :authorize

  def index
    r = Reddit::Api.new
  	@articles = r.browse("", {:limit => 100, :section => "hot", :cookie => session[:cookie]})
    @subs = subs
    if stale? etag: [@articles, current_session]
      respond_to do |format|
        format.html
        format.xml {render xml: @articles}
      end
    end
  end

  def saved
    r = Reddit::Api.new
    @saved_articles = r.saved({:limit => 100, :cookie => session[:cookie], :user => params[:user].to_s})
    @subs = subs
    if stale? etag: [@articles, current_session]
      respond_to do |format|
        format.html
        format.xml {render xml: @saved_articles}
      end
    end
  end


  def show
    @original_url = Base64.urlsafe_decode64(params[:id]).to_s
    @submission = params[:submission]
    @subreddit = params[:subreddit].to_s
    @submission_id = params[:submission][:id].gsub("t3_","")
    @submission_title = params[:submission][:title].downcase.gsub(" ","_")
    @reddit_url = "http://reddit.com/r/" + @subreddit + "/comments/" + @submission_id + "/" + @submission_title
    @article = Diffbot::Article.fetch(@original_url) do |request|
      request.html = true # Return HTML instead of plain text.
      request.dont_strip_ads = false # Leave any inline ads within the article.
      request.tags = true # Generate ads for the article.
      request.summary = true # Return a summary text instead of the full text.
      request.stats = true # Return performance, probabilistic scoring stats.
    end
    logger.info "#{@article.stats}"
    @subs = subs
    if stale? etag: [@article, current_session]
      respond_to do |format|
        format.html
        format.xml {render xml: @articles}
      end
    end
  end

  def subreddit
    r = Reddit::Api.new
  	@articles = r.browse("#{params[:id]}", {:limit => 100, :section => "hot",:cookie => session[:cookie]})
    @subs = subs
    if stale? etag: [@article, current_session]
      respond_to do |format|
        format.html
        format.xml {render xml: @articles}
      end
    end
  end

end
