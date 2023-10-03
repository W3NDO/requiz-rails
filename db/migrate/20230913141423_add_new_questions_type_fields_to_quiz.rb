class AddNewQuestionsTypeFieldsToQuiz < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :questions_type, :string, array: true, default: []
  end
end
