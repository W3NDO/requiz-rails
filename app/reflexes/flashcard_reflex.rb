# frozen_string_literal: true

class FlashcardReflex < ApplicationReflex
  def start_flash_session
    quiz = Quiz.find(element.dataset["id"])
    flashcards = quiz.flashcards
    morph "#main_container", render(:partial => "quizzes/flashcard", :locals => {:flashcards => flashcards, :quiz => quiz  } )
    # morph :nothing
  end
end
