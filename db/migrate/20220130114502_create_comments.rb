class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :commentable, polymorphic: true, null: false
      t.integer :parent_id
      t.text :content

      t.jsonb :payload, null: false, default: {}

      t.timestamps
    end
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
    add_index :comments, :payload, using: :gin
  end
end
