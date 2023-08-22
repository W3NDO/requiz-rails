class AddScoreToQuiz < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :score, :float
  end
end
