class AddPublicIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :public_id, :string
  end
end
