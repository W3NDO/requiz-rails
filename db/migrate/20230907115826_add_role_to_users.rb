class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :role, :integer, default: 1

    User.reset_column_information
  end

  def down
    remove_column :users, :role
  end
end
