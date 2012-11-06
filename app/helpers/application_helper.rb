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
end
