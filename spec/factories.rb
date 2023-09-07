FactoryBot.define do
  factory :user do
    email {"testmail@example.com"}
    password {"foobar123"}
    password_confirmation {"foobar123"}
    full_name {"Test User"}
  end

  factory :unprocessed_quiz do
    title { "This quiz will not have been processed" }
    tag { "quiz, test, unprocessed" }
    quiz_file { "" }
  end

  factory :processed_quiz do
    title { "This quiz is processed" }
    tag { "quiz, test, processed" }
    quiz_file { "" }
  end
end