class AddTokenToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :tokens, :text
    add_column :users, :allow_password_change, :boolean, default: false

    User.reset_column_information

    User.find_each do |user|
      user.uid = user.email
      user.provider = 'email'
      user.save!
    end

    add_index :users, [:uid, :provider], unique: true
  end

  def down
    remove_columns :users, :provider, :uid, :tokens
  end
end
