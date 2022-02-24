class AddContentTypeToPostAndComment < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :content_type, :integer, default: 0, null: false
    add_column :comments, :content_type, :integer, default: 0, null: false
  end
end
