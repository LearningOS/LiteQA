class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content
      t.integer :post_type
      t.integer :status
      t.integer :cid

      t.belongs_to :user, foreign_key: true

      t.jsonb :payload, null: false, default: {}

      t.timestamps
    end
    add_index :posts, :payload, using: :gin
    add_index :posts, %i[user_id created_at]
  end
end
