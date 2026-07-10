class AddUniqueIndexToOnboardingsUserId < ActiveRecord::Migration[8.1]
  def change
    remove_index :onboardings, :user_id
    add_index :onboardings, :user_id, unique: true
  end
end
