class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, optional: true, class_name: "Comment"
  has_many :comments, foreign_key: :parent_id, dependent: :destroy
  default_scope { with_rich_text_rich_content_and_embeds }

  has_rich_text :rich_content

  store_accessor :payload, :raw_comment, :type

  def content
    self.rich_content || self["content"] || ""
  end

  def comments
    Comment.where(commentable: commentable, parent_id: id)
  end
end
