module ApplicationHelper
	def app_revision
    	revision_file = File.join(Rails.root, "VERSION")
    	if File.readable?(revision_file)
      		IO.read(revision_file)
    	else
      		"unknown"
    	end
  	end
	def title(page_title)
  		content_for(:title) { page_title }
	end

  # def is_saved(story_id)
  #   r = Reddit::Api.new
  #   @saved_articles = r.saved({:limit => 100, :cookie => session[:cookie], :user => session[:user].to_s})
  #   @saved_articles.each do |article|
  #     if article.name == story_id
  #       return true
  #     end
  #   end
  #   return false
  # end
end
