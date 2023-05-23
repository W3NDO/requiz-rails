require 'rails_helper'

RSpec.describe "quizzes/index", type: :view do
  before(:each) do
    assign(:quizzes, [
      Quiz.create!(
        questions: "",
        title: "Title"
      ),
      Quiz.create!(
        questions: "",
        title: "Title"
      )
    ])
  end

  it "renders a list of quizzes" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
  end
end
