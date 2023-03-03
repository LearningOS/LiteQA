# frozen_string_literal: true

# This migration comes from action_store (originally 20181121052638)
class AddUniqueIndexToActions < ActiveRecord::Migration[5.2]
  def change
    add_index :actions, %i[action_type target_type target_id user_type user_id], unique: true,
                                                                                 name: :uk_action_target_user
  end
end
