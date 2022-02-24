# frozen_string_literal: true

class PostFeedItemComponent < ViewComponent::Base
  def initialize(post:)
    @post = post
  end

end
