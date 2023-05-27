class AddFilePrcessedEnumToQuiz < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :processed, :integer
  end
end
