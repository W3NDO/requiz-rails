class AddUserIdToTopic < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :user_id, :int
    add_foreign_key :topics, :users
  end
end
