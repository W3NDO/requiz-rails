class AddTopicIdToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :topic_id, :int
  end
end
