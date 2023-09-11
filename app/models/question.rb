class Question < ApplicationRecord
  # has_rich_text :question
  # has_rich_text :answer
  belongs_to :quiz, dependent: :destroy

  enum :question_type, [:multiple_choice, :true_false, :short_answer], default: :multiple_choice
end
