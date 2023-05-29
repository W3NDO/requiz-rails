class CreateFlashcards < ActiveRecord::Migration[7.0]
  def change
    create_table :flashcards do |t|
      t.string :question
      t.string :tag
      t.string :answer
      t.integer :quiz_id

      t.timestamps
    end
  end
end
