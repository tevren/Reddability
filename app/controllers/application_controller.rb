require 'digest/sha1'
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_session, :cache_key, :subs

  def subs
    subs = Array.new    
    if session[:cookie]
      r = Reddit::Api.new
      mine = r.mine({:limit => 75, :cookie => session[:cookie]})
      unless mine.nil?
        mine.map(&:url).each do |subreddit_url|
          subreddit = subreddit_url.to_s.gsub("/r/","").gsub(/\//,"")
          subs.push(subreddit)
        end
      end
    else
      r = Reddit::Api.new
      mine = r.mine({:limit => 75})
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
  
  def cache_key
    if session[:cookie]
      cachekey = Digest::SHA1.hexdigest(session[:cookie].to_s.gsub(";","_").gsub(" ", "_"))
    else 
      cachekey = Digest::SHA1.hexdigest("no_user_here")
    end
  end

  def authorize
    redirect_to login_url if session[:cookie].nil?
  end
end
