class Myreddit
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :title, :url, :subreddit, :source, :server

  def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
        puts "#{name}=#{value}"
      end
  end

  def persisted?
    false
  end
end
