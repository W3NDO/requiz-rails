# frozen_string_literal: true

class QuizReflex < ApplicationReflex
  
  def add_questions
    quiz = Quiz.find(element.dataset["id"]) || Quiz.new
    morph "#quiz_main", render(
      partial: "quizzes/form", 
      :locals => {
        :object => quiz
      }
    )
  end

end
