class AddUserIdToQuiz < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :user_id, :integer
  end
end
