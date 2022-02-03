# frozen_string_literal: true

class PostFeedItemComponent < ViewComponent::Base
  def initialize(post:)
    @post = post
    @content_snipet = truncate(Nokogiri::HTML.parse(@post.content).text, length: 80)
  end

end
