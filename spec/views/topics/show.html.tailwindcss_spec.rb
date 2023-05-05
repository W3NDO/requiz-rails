require 'rails_helper'

RSpec.describe "topics/show", type: :view do
  before(:each) do
    assign(:topic, Topic.create!(
      topic_name: "Topic Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Topic Name/)
  end
end
