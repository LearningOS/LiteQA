class Post < ApplicationRecord
  belongs_to :user, optional: true
  has_many :post_tags
  has_many :tags, :through => :post_tags
  has_many :comments, as: :commentable

  enum post_type: { question: 0, note: 1, poll: 2 }

  auto_increment :cid, model_scope: nil, force: false, lock: true, before: :create

  store_accessor  :payload, :raw_post, :raw_feed

  default_scope { order(created_at: :desc) }
  scope :pinned, -> { includes(:tags).where(tags: {name: "pin"}) }
  scope :unpinned, -> { includes(:tags).where.not(tags: {name: "pin"}) }

  def instructor_note?
    tags.where(name: "instructor-note").any?
  end
end