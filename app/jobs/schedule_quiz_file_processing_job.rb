class ScheduleQuizFileProcessingJob < ApplicationJob
include QuizzesHelper
  queue_as :urgent

  def perform(quiz)
    # Do something later
    set_quizzer_requests
    res = nil
    quiz.quiz_file.attachment.open do |file|
      request_body = {:excerpt => file.read.gsub("\n", " ")}
      res = @qr.process_quiz_request(request_body)
    end
    if quiz.update!(request_id: res[:request_id])
      CheckQuizProcessingStatusJob.perform_later(quiz, @qr.token)
      quiz.analyzing!
    else
      raise Exception.new("Unable to update quiz #{quiz.title}")
    end
  end

  private
  def set_quizzer_requests
    @qr = QuizzesHelper::QuizzerRequests.new(ENV['FILE_PROCESSOR_USER'], ENV['FILE_PROCESSOR_PASS'])
    @qr.login
  end

end
