require 'openai'
module RequizOpenai
  class OpenaiService
    # Constant Definition
    QUESTIONS_PER_100_WORDS = 2
    MAXIMUM_TOKEN_LENGTH = 3500
    CLIENT = OpenAI::Client.new

    def devputs(text)
      if Rails.env.development?
        puts text
      end
    end
    
    def number_of_questions_to_generate(word_count)
      return (word_count/100)*QUESTIONS_PER_100_WORDS
    end
    
    #prompt handler take in a prompt_type and return a prompt
    def get_prompt(question_type, number_of_questions_to_generate, text)
      # question_type is an array of symbols
      prompts = {
        :multiple_choice => "Generate a list of #{number_of_questions_to_generate} multiple choice questions. Use the following piece of text to generate the questions. \n #{text}. Return them as a json object of #{number_of_questions_to_generate} #{'entry'.pluralize(number_of_questions_to_generate)} with the following structure: {\"questions\" : [{\"Question\": ..., \"Correct Answer\": ..., \"Possible Answers\": [] }] }",
        :true_false => "Generate a list of #{number_of_questions_to_generate} true or false questions. Use the following piece of text to generate the questions. \n #{text}. Return them as a json object of #{number_of_questions_to_generate} #{'entry'.pluralize(number_of_questions_to_generate)} with the following structure: {\"questions\" : [{\"Question\": ..., \"Correct Answer\": ..., \"Possible Answers\": [] }] }",
      }
      return prompts[question_type.to_sym] || prompts[:multiple_choice] 
    end

    def parse_to_json(response)
      devputs "#{response.class} :: #{response}"
      JSON.parse(response, {symbolize_names: true})
    end

    # Request Handler
    # TODO figure out a chunking strategy for the requests if the text is long
    def make_request(text, question_type) # we extract this into a function in order to implement a chunking strategy for long text requests
      word_count = text.split(' ').size
      number_of_questions_to_generate = number_of_questions_to_generate(word_count) 
      prompts = {}
      question_type.each do |q_type|
        prompts[q_type] = get_prompt(q_type, number_of_questions_to_generate, text)
      end
      returned_questions = {}

      prompts.each do |question_type, prompt|
        response = CLIENT.chat(
          parameters: {
            model: "gpt-3.5-turbo", # Required.
            messages: [
              { 
                :role => "user", 
                :content => prompt
              }
            ], # Required.
          },
        )
        returned_questions[question_type.to_sym] = parse_to_json(response.dig("choices", 0, "message", "content"))
      end
      
      return returned_questions.to_json
    end

    # token estimator function
    def token_estimator(text)
      OpenAI.rough_token_count(text)
    end

  end
end