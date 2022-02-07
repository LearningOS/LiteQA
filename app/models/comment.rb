class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, optional: true, class_name: "Comment"
  has_many :comments, foreign_key: :parent_id, dependent: :destroy

  store_accessor :payload, :raw_comment, :type

  def comments
    Comment.where(commentable: commentable, parent_id: id)
  end
end
