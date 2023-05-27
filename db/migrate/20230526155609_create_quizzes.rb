class CreateQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :quizzes do |t|
      t.jsonb :tag
      t.string :title

      t.timestamps
    end
  end
end
