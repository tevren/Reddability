module RedditsHelper
	def sanitize_article(article)
		if article.best_candidate_has_image && article.images.nil?
			article = article.load_image(article)
		else
			sanitize article.content
		end
	end
end
