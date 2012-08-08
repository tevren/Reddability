class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_session, :subs

  def subs
    subs = Array.new    
    if session[:cookie]
      r = Reddit::Api.new
      mine = r.mine({:limit => 100, :cookie => session[:cookie]})
      unless mine.nil?
        mine.map(&:url).each do |subreddit_url|
          subreddit = subreddit_url.to_s.gsub("/r/","").gsub(/\//,"")
          subs.push(subreddit)
        end
      end
    end
    subs = subs.sort! { |a,b| a.downcase <=> b.downcase }
    return subs
  end
  private

  def current_session
    if session[:cookie]
      @current_session = session[:cookie]
    else 
      @current_session = nil
    end
  end
  
  def authorize
    redirect_to login_url if session[:cookie].nil?
  end
end
