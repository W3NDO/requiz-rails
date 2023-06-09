require 'rails_helper'

RSpec.describe "questions/new", type: :view do
  before(:each) do
    assign(:question, Question.new(
      tag: "",
      question: "MyString",
      answer: "MyString"
    ))
  end

  it "renders new question form" do
    render

    assert_select "form[action=?][method=?]", questions_path, "post" do

      assert_select "input[name=?]", "question[tag]"

      assert_select "input[name=?]", "question[question]"

      assert_select "input[name=?]", "question[answer]"
    end
  end
end
