require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
def create_user
    User.create!(
        full_name:  Faker::Name.name,
        email:  Faker::Internet.email,
        password:  "foobar123",
        password_confirmation:  "foobar123",
        handle:  Faker::Internet.username(specifier: 5..8),
    )
end

def create_questions(quiz_id)
    answer = Faker::Movies::HarryPotter.character
    choices = []
    3.times do
        choices << Faker::Movies::HarryPotter.character
    end
    Question.create(
        quiz_id: quiz_id,
        question: "Who said these words: `#{Faker::Movies::HarryPotter.quote}`",
        answer: answer,
        possible_answers: (choices << answer).shuffle,
        tag: "Harry Potter"
    )
end

def create_quiz(user_id)
    q = Quiz.create(
        title: "Harry Potter Quiz #{rand(0..100)}",
        tag: "Harry Potter",
        user_id: user_id
    )
    4.times do 
        create_questions(q.id)
    end
end

u = create_user
create_quiz(u.id)

5.times do
    create_quiz(1)
end

