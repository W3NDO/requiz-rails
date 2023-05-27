require 'rails_helper'

RSpec.describe "quizzes/show", type: :view do
  before(:each) do
    assign(:quiz, Quiz.create!(
      tag: "",
      title: "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Title/)
  end
end
