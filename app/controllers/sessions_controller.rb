class SessionsController < ApplicationController
  attr_accessor :reddit
  def new
  end

  def create
    @reddit = Reddit::Api.new(params[:user],params[:password])
    @reddit.login
    if  @reddit.logged_in? && !@reddit.cookie.nil?
      session[:cookie] = @reddit.cookie
      session[:user] = @reddit.user
      redirect_to root_url, notice: "Logged in! Welcome #{@reddit.user}!"
      expire_fragment(["index",cache_key])
      expire_fragment(["subs",cache_key])
    else
      redirect_to login_url, alert: "Invalid credentials, please wait 15 seconds before your next attempt." 
    end
  end


  def destroy
    expire_fragment(["index",cache_key])
    expire_fragment(["subs",cache_key])
    session[:cookie] = nil
    session[:user] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
