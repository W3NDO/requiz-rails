require 'openai'
class ScheduleQuizFileProcessingJob < ApplicationJob
include QuizzesHelper
  queue_as :urgent
  QUESTIONS_PER_100_WORDS = 2
  MAXIMUM_TOKEN_LENGTH = 3500

  def perform(quiz)
    # Do something later
    client = client = OpenAI::Client.new
    is_pdf = quiz.quiz_file.blob.filename.extension_with_delimiter == ".pdf"
    quiz.quiz_file.attachment.open do |file|
      text = get_text(file, is_pdf)
      # generate 2 questions per 100 words.
      word_count = text.split(" ").length
      number_of_questions_to_generate = (word_count/100)*QUESTIONS_PER_100_WORDS
      # puts "TEXT: #{text}. \n#QUESTIONS_TO_GENERATE: #{number_of_questions_to_generate}"
      
      response = client.chat(
          parameters: {
              model: "gpt-3.5-turbo", # Required.
              messages: [
                { 
                  role: "user", 
                  content: "Generate a list of #{number_of_questions_to_generate} multiple choice questions. Use the following piece of text to generate the questions. \n #{text}.  return them in json format with the following structure: {\"questions\" : {\"Question\": ..., \"Correct Answer\": ..., \"Possible Answers\": [] } }"
                }
              ], # Required.
              # functions: [
              #   {
              #     name: "get_questions",
              #     description: "Get Questions from the passed text",
              #     parameters: {
              #       type: :object,
              #       properties: {
              #         questions: {
              #           type: :object,
              #           description: "List of generated questions and Answers",
              #           properties: {
              #             question: {
              #               type: :string,
              #               description: "The generated question"
              #             },
              #             correct_answer: {
              #               type: "string",
              #               description: "The correct answer",
              #             },
              #             possible_answers: {
              #               type: "array",
              #               description: "A list of possible answers",
              #               items: {
              #                 type: "string",
              #               },
              #             },
              #           },
              #         },
              #       },
              #       required: ["question", "correct_answer", "possible_answers"]
              #     },
              #   },
              # ],
            },
          )
      returned_questions = response.dig("choices", 0, "message", "content")
      # puts "Got A response from ChatGPT. #{ response }"
      # puts returned_questions
      pp response
      
      # function_name = response.dig("function_call", "name")
      # puts response.dig("function_call", "arguments")
      # args = JSON&.parse(response.dig("function_call", "arguments"), {symbolize_names: true})
      
      # pp args
      if returned_questions  
        parsed_questions = parse_to_json(returned_questions)
        pp "PARSED::  #{parsed_questions}"
        build_questions_from_hash(parsed_questions, quiz)
      end
    end
  end

  private
  def parse_to_json(response)
    JSON.parse(response, {symbolize_names: true})
  end

  def get_text(file, is_pdf) # TODO should also estimate the tokens cost and try to shorten it.
    text = ""
    if is_pdf
      pdf_file = PDF::Reader.new(file)
      pdf_file.pages.each do |page|
        text = text + page&.text&.gsub("\n", " ")&.squeeze(" ")
      end
      pp "TEXT to TOKEN ESTIMATE #{OpenAI.rough_token_count(text)}"
    else
      pp "TEXT to TOKEN ESTIMATE #{OpenAI.rough_token_count(text)}"
      text = file.read.gsub("\n", " ").squeeze(" ")
    end
    
    token_estimate = OpenAI.rough_token_count(text)
    if token_estimate > MAXIMUM_TOKEN_LENGTH
      return text[..MAXIMUM_TOKEN_LENGTH*4]
    else
      return text
    end
  end

  def build_questions_from_hash(questions_hash, quiz)
    puts "QUESTIONS HASH #{questions_hash}"
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
  end

end
