class AddQuizFileToQuiz < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :quiz_file, :string
  end
end
