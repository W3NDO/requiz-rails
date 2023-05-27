class AddPossibleAnswersToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :possible_answers, :string, array: true, default: []
  end
end
