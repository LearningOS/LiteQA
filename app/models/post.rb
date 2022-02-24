class Post < ApplicationRecord
  belongs_to :user, optional: true
  has_many :post_tags
  has_many :tags, :through => :post_tags
  has_many :comments, as: :commentable

  has_rich_text :rich_content

  enum post_type: { question: 0, note: 1, poll: 2 }
  enum content_type: { rich_content: 0, markdown: 1, raw: 2 }

  auto_increment :cid, model_scope: nil, force: false, lock: true, before: :create

  store_accessor :payload, :raw_post, :raw_feed

  default_scope { order(created_at: :desc) }
  scope :pinned, -> { where(pin: true) }
  scope :unpinned, -> { where(pin: false) }

  def content
    case self.content_type
    when "rich_content"
      self.rich_content
    when "markdown"
      self["content"]
    when "raw"
      self["content"]
    else
      ""
    end
  end

  def content_snipet
    case self.content_type
    when "rich_content"
      self.rich_content.to_plain_text.truncate(80)
    when "markdown"
      self["content"].truncate(80)
    when "raw"
      strip_tags(self["content"]).truncate(80)
    else
      ""
    end
  end
end
