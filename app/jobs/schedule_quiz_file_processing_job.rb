class ScheduleQuizFileProcessingJob < ApplicationJob
  queue_as :urgent

  def perform(quiz)
    # Do something later
    pp "Building Questions for Quiz: #{quiz.title}"
    questions_to_save = []
    flashcards_to_save = []
    quiz.quiz_file.attachment.open do |file|
      CSV.parse(file, headers: false) do |row|
        row = row.to_csv.split(",")
        new_question = {
          :question => row[0],
          :possible_answers => row[1..-2],
          :answer => row[-1].chomp,
          :quiz_id => quiz.id,
          :tag => quiz.tag
        }
        new_flashcard = {
          :question => row[0]
          :answer => row[-1].chomp,
          :quiz_id => quiz.id,
          :tag => quiz.tag 
        }
        questions_to_save << new_question
        flashcards_to_save << new_flashcard

      end
    end
    if Question.insert_all(questions_to_save) and Flashcard.insert_all(flashcards_to_save)
      quiz.analyzed!
      pp "Quiz: #{quiz.title}  has been analyzed and the questions and flashcards have been prepared."
    end
  end
end
