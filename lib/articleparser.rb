require 'Base64'
require 'readability'
require 'open-uri'
require 'ostruct'
require 'httparty'

class ArticleParser
  attr_reader :content, :title, :tags, :encoded_url

  def initialize(encoded_url,user_options = {})
    @encoded_url = encoded_url
    @options = user_options
    @original_url = Base64.urlsafe_decode64(@encoded_url).to_s
  end


  def run
    begin
      source = HTTParty.get(@original_url).body
#      source = open(@original_url).read
      @article =  Readability::Document.new(source,@options)
    rescue => e
    case e
    when OpenURI::HTTPError
      puts "HTTPError: '#{e}' for #{uri}"
    when Zlib::BufError
      puts "Zlib::BufError: '#{e}' for #{uri}"
    else
      raise "exception is #{e}"
    end
    end
    
  end
end