require 'rails_helper'

RSpec.describe "subtopics/show", type: :view do
  before(:each) do
    assign(:subtopic, Subtopic.create!(
      topic_name: "Topic Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Topic Name/)
  end
end
