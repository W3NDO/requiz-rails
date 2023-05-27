require 'rails_helper'

RSpec.describe "questions/show", type: :view do
  before(:each) do
    assign(:question, Question.create!(
      tag: "",
      question: "Question",
      answer: "Answer"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Question/)
    expect(rendered).to match(/Answer/)
  end
end
