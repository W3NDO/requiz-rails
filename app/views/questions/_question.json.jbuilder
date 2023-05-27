json.extract! question, :id, :tag, :question, :answer, :created_at, :updated_at
json.url question_url(question, format: :json)
