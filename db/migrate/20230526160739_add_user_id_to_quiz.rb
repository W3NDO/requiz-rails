class AddUserIdToQuiz < ActiveRecord::Migration[7.0]
  def up
    add_column :quizzes, :user_id, :integer
  end

  def down
    remove_column :quizzes, :user_id
  end
end
