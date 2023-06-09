require 'rails_helper'

RSpec.describe "quizzes/edit", type: :view do
  let(:quiz) {
    Quiz.create!(
      tag: "",
      title: "MyString"
    )
  }

  before(:each) do
    assign(:quiz, quiz)
  end

  it "renders the edit quiz form" do
    render

    assert_select "form[action=?][method=?]", quiz_path(quiz), "post" do

      assert_select "input[name=?]", "quiz[tag]"

      assert_select "input[name=?]", "quiz[title]"
    end
  end
end
