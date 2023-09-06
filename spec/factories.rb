FactoryBot.define do
  factory :user do
    email {"testmail@example.com"}
    password {"foobar123"}
    password_confirmation {"foobar123"}
    full_name {"Test User"}
  end
end