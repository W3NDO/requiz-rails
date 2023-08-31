require 'openai'
class ScheduleQuizFileProcessingJob < ApplicationJob
include QuizzesHelper
  queue_as :urgent
  QUESTIONS_PER_100_WORDS = 2

  def perform(quiz)
    # Do something later
    client = client = OpenAI::Client.new

    quiz.quiz_file.attachment.open do |file|
      text = file.read.gsub("\n", " ")
      # generate 2 questions per 100 words.
      word_count = text.split(" ").length
      number_of_questions_to_generate = (word_count/100)*QUESTIONS_PER_100_WORDS
      # puts "TEXT: #{text}. \n#QUESTIONS_TO_GENERATE: #{number_of_questions_to_generate}"
      response = client.chat(
          parameters: {
              model: "gpt-3.5-turbo", # Required.
              messages: [{ 
                role: "user", 
                content: "Generate a list of #{number_of_questions_to_generate} multiple choice questions. Use the following piece of text to generate the questions. \n #{text}.  return them in json format with the following structure: {\"questions\" : {\"Question\": ..., \"Correct Answer\": ..., \"Possible Answers\": [] } }"
              }], # Required.
              temperature: 0.7,
          })
      returned_questions = response.dig("choices", 0, "message", "content")
      puts returned_questions
      parsed_questions = parse_to_json(returned_questions)
      pp "PARSED::  #{parsed_questions}"
      build_questions_from_hash(parsed_questions, quiz)
    end
  end

  private
  def parse_to_json(response)
    JSON.parse response
  end

  def build_questions_from_hash(questions_hash, quiz)
    questions = questions_hash["questions"]
    question_objects = []
    questions.each do |question|
      temp = Hash.new
      temp[:question] = question["Question"] || question[ question.keys.select{ |q| q.starts_with("Question") } ] # because it returns Question or Question 1
      temp[:answer] = question["Correct Answer"]
      temp[:possible_answers] = question["Possible Answers"]
      temp[:possible_answers] << question["Correct Answer"]
      temp[:quiz_id] = quiz.id
      temp[:tag] = quiz.tag
      question_objects << temp
    end
    Question.create!(question_objects)
    quiz.analyzed!
  end

end
