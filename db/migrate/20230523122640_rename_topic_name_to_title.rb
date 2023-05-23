class RenameTopicNameToTitle < ActiveRecord::Migration[7.0]
  def up
    rename_column :topics, :topic_name, :title
  end

  def down
    rename_column :topics, :title, :topic_name
  end
end
