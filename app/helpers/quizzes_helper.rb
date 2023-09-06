module QuizzesHelper
  # class QuizzerRequests
  #   include HTTParty
  #   base_uri ENV['FILE_PROCESSOR_URI']
    

  #   def initialize(user=nil, pass=nil, token=nil)
  #     @auth = {"name" => user, "password" => pass} unless token
  #     @token = token if token
  #     @base_url =  ENV['FILE_PROCESSOR_URI']
  #   end

  #   def token
  #     @token
  #   end
  

  #   def login()
  #     headers = {'Content-Type': 'application/json', 'Accept' => 'application/json'}
  #     res = HTTParty.post("#{@base_url}/login", body: @auth.to_json, headers: headers)
  #     case res.code
  #     when 200
  #       @token = JSON.parse(res.body)["token"]
  #       return @token
  #     when 401
  #       return "Unauthorised"
  #     else
  #       raise Exception.new "Error Occured when trying to communicate with the quiz processing server. Failed with code #{res.code}"
  #     end
  #   end
    
  #   def process_quiz_request(quiz_details)
  #     headers = {
  #       'Content-Type' => 'application/json',
  #       'Authorization' => @token
  #     }
  #     res = HTTParty.post("#{@base_url}/process_quiz", body: quiz_details.to_json, headers: headers)
  #     if res.code == 200
  #       parsed = JSON.parse(res.body)
  #       return {
  #         :request_id => parsed["request_id"],
  #         :status => parsed["status"]
  #       }
  #     else
  #       raise Exception.new "Unable to upload excerpt for parsing. Failed with error #{res.code}"
  #     end
  #   end

  #   def check_processed_status(request_id)
  #     headers = {
  #       'Content-Type' => 'application/json',
  #       'Authorization' => @token
  #     }
  #     res = HTTParty.get("#{@base_url}/check_quiz?request_id=#{request_id}",  headers: headers)
  #     if res.code == 200
  #       body = JSON.parse(res.body)
  #       return body
  #     elsif res.code == 404
  #       raise Exception.new "Quiz with request id: #{request_id} does not exist"
  #     else
  #       raise Exception.new "Unknown Exception occurred. Failed with Error #{res.code}"
  #     end
  #   end
  # end
end
