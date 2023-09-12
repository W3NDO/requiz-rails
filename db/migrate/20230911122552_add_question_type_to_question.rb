class AddQuestionTypeToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :question_type, :integer

    Question.all.each { |q| q.multiple_choice! }
  end
end
