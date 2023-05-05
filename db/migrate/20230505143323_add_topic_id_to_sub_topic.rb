class AddTopicIdToSubTopic < ActiveRecord::Migration[7.0]
  def change
    add_column :subtopics, :topic_id, :int
    add_foreign_key :subtopics, :topics
  end
end
