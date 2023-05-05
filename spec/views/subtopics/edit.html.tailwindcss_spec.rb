require 'rails_helper'

RSpec.describe "subtopics/edit", type: :view do
  let(:subtopic) {
    Subtopic.create!(
      topic_name: "MyString"
    )
  }

  before(:each) do
    assign(:subtopic, subtopic)
  end

  it "renders the edit subtopic form" do
    render

    assert_select "form[action=?][method=?]", subtopic_path(subtopic), "post" do

      assert_select "input[name=?]", "subtopic[topic_name]"
    end
  end
end
