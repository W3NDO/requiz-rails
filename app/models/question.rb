class Question < ApplicationRecord
  has_rich_text :question
  has_rich_text :answer
  belongs_to :quiz
end
