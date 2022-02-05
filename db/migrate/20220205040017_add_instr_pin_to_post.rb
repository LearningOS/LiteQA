class AddInstrPinToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :pin, :boolean, default: false
    add_column :posts, :instructor_note, :boolean, default: false
    add_index :posts, :pin
    add_index :posts, :instructor_note
  end
end
