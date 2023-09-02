class GenerateFlashCardsJob < ApplicationJob
  queue_as :default

  def perform(quiz)
    # Do something later
    flashcards_to_build = []
    questions = quiz.questions
    questions.each do |question|
      temp = {
        :question => question.question,
        :answer => question.answer,
        :quiz_id => quiz.id
      }
      flashcards_to_build << temp
    end
    Flashcard.create(flashcards_to_build)
  end
end
