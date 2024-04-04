require 'openai'
require_relative '../services/requiz_openai/openai_service'
class ScheduleQuizFileProcessingJob < ApplicationJob
# before_perform :set_client

include QuizzesHelper
  queue_as :urgent
  QUESTIONS_PER_100_WORDS = 2
  MAXIMUM_TOKEN_LENGTH = 3500
  
  def perform(quiz)
    # Do something later
    service = RequizOpenai::OpenaiService.new
    is_pdf = quiz.quiz_file.blob.filename.extension_with_delimiter == '.pdf'
    quiz.quiz_file.attachment.open do |file|
      text = get_text(file, is_pdf)
      question_type = quiz.questions_type.map{ |q| q.to_sym }
      response = service.make_request(text, question_type)
      devputs response
  
      if response
        questions = JSON.parse(response)
        build_questions_from_hash(questions, quiz)
      end
    end
  end

  private
  def get_text(file, is_pdf) # TODO should also estimate the tokens cost and try to shorten it.
    text = ""
    if is_pdf
      pdf_file = PDF::Reader.new(file)
      pdf_file.pages.each do |page|
        text = text + page&.text&.gsub("\n", " ")&.squeeze(" ")
      end
      devputs "TEXT to TOKEN ESTIMATE #{OpenAI.rough_token_count(text)}"
    else
      devputs "TEXT to TOKEN ESTIMATE #{OpenAI.rough_token_count(text)}"
      text = file.read.gsub("\n", " ").squeeze(" ")
    end
    
    token_estimate = OpenAI.rough_token_count(text)
    if token_estimate > MAXIMUM_TOKEN_LENGTH
      # if the text is too long, split it into multiple requests
      # number_of_splits = MAXIMUM_TOKEN_LENGTH/(token_estimate - MAXIMUM_TOKEN_LENGTH)
      return text[..MAXIMUM_TOKEN_LENGTH*2]
    else
      return text
    end
  end

  def build_questions_from_hash(questions_hash, quiz)
    # devputs "QUESTIONS HASH #{questions_hash}"
    devputs "-------------------------------------- \n"
    pp questions_hash 
    devputs "-------------------------------------- \n"

    question_objects = []
    questions_hash.each do |question_type, questions_list|
      questions = questions_list["questions"]
      questions.each do |question|
        temp = Hash.new
        temp[:question] = question["Question"]
        temp[:answer] = question["Correct Answer"]
        temp[:possible_answers] = question["Possible Answers"]
        if question["Possible Answers"].exclude? question["Correct Answer"]
          temp[:possible_answers] << question["Correct Answer"]
        end
        temp[:quiz_id] = quiz.id
        temp[:tag] = quiz.tag
        temp[:question_type] = question_type

        question_objects << temp
      end

    end
    # pp question_objects
    Question.create!(question_objects)
    quiz.analyzed!
    GenerateFlashCardsJob.perform_later(quiz) unless quiz.has_questions?
  end

end
