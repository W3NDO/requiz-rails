class AddRequestIdToQuiz < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :request_id, :string
  end
end
