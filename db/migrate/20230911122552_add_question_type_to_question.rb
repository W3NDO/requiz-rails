class AddQuestionTypeToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :question_type, :integer

    Question.reset_column_information
  end
end
