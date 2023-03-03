class RemoveTags < ActiveRecord::Migration[7.0]
  def change
    drop_table :post_tags
    drop_table :tags
  end
end
