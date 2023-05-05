require 'rails_helper'

RSpec.describe "subtopics/new", type: :view do
  before(:each) do
    assign(:subtopic, Subtopic.new(
      topic_name: "MyString"
    ))
  end

  it "renders new subtopic form" do
    render

    assert_select "form[action=?][method=?]", subtopics_path, "post" do

      assert_select "input[name=?]", "subtopic[topic_name]"
    end
  end
end
