class CheckQuizProcessingStatusJob < ApplicationJob
  queue_as :default

  def perform(quiz, token)
    # Do something later
    @qr = QuizzesHelper::QuizzerRequests.new(nil, nil, token)
    token = @qr.token
    request_id = quiz.request_id
    response = @qr.check_processed_status(request_id)
    pp response["processed"]
    
    if response["processed"] == true
      pp "Creating Questions..."
      questions = []
      response["questions"]&.each do |question|
        questions << {
          question: question["question"],
          answer: question["actual_answer"],
          possible_answers: question["possible_answers"],
          quiz_id: quiz.id,
          tag: quiz.tag
        }
      end
      Question.create(questions)
      quiz.analyzed!
    else
      pp "Questions not ready. Checking again in 2 minutes."
      CheckQuizProcessingStatusJob.set(wait_until: Time.now + 2.minutes).perform_later(quiz, token) # wait and then recheck
    end
  end
end
