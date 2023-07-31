class AddHasFlashcardsToQuiz < ActiveRecord::Migration[7.0]
  def change
      add_column :quizzes, :has_flashcards, :boolean
  end
end
