require 'openai'
class ScheduleQuizFileProcessingJob < ApplicationJob
# before_perform :set_client

include QuizzesHelper
  queue_as :urgent
  QUESTIONS_PER_100_WORDS = 2
  MAXIMUM_TOKEN_LENGTH = 3500
  
  def perform(quiz)
    # Do something later
    @client = OpenAI::Client.new
    is_pdf = quiz.quiz_file.blob.filename.extension_with_delimiter == ".pdf"
    quiz.quiz_file.attachment.open do |file|
      text = get_text(file, is_pdf)
      # generate 2 questions per 100 words.
      word_count = text.split(" ").length
      number_of_questions_to_generate = (word_count/100)*QUESTIONS_PER_100_WORDS
      # devputs "TEXT: #{text}. \n#QUESTIONS_TO_GENERATE: #{number_of_questions_to_generate}"
      
      response = make_request(@client, text, number_of_questions_to_generate)
      returned_questions = response.dig("choices", 0, "message", "content")
      # devputs "Got A response from ChatGPT. #{ response }"
      # devputs returned_questions
      devputs response
      
      # function_name = response.dig("function_call", "name")
      # devputs response.dig("function_call", "arguments")
      # args = JSON&.parse(response.dig("function_call", "arguments"), {symbolize_names: true})
      
      # devputs args
      if returned_questions  
        parsed_questions = parse_to_json(returned_questions)
        devputs "PARSED::  #{parsed_questions}"
        build_questions_from_hash(parsed_questions, quiz)
      end
    end
  end

  private
  def set_client
    @client = OpenAI::Client.new
  end

  def parse_to_json(response)
    devputs "#{response.class} :: #{response}"
    JSON.parse(response, {symbolize_names: true})
  end

  def make_request(client, text, number_of_questions_to_generate) # we extract this into a function in order to implement a chinking strategy for long text requests
    client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [
          { 
            role: "user", 
            content: "Generate a list of #{number_of_questions_to_generate} multiple choice questions. Use the following piece of text to generate the questions. \n #{text}.  return them as a json object of #{number_of_questions_to_generate} #{'entry'.pluralize(number_of_questions_to_generate)} with the following structure: {\"questions\" : [{\"Question\": ..., \"Correct Answer\": ..., \"Possible Answers\": [] }] }"
          },
        ], # Required.
      },
    )
  end

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
    devputs "QUESTIONS HASH #{questions_hash}"
    questions = questions_hash[:questions]
    question_objects = []
    questions.each do |question|
      temp = Hash.new
      temp[:question] = question[:Question] || question[ question.keys.select{ |q| q.to_s.starts_with("Question") } ] # because it returns Question or Question 1
      temp[:answer] = question[:"Correct Answer"]
      temp[:possible_answers] = question[:"Possible Answers"]
      temp[:possible_answers] << question[:"Correct Answer"]
      temp[:quiz_id] = quiz.id
      temp[:tag] = quiz.tag
      question_objects << temp
    end
    Question.create!(question_objects)
    quiz.analyzed!
    GenerateFlashCardsJob.perform_later(quiz) unless quiz.has_questions?
  end

end
