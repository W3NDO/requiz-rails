require 'rails_helper'

RSpec.describe "topics/index", type: :view do
  before(:each) do
    assign(:topics, [
      Topic.create!(
        topic_name: "Topic Name"
      ),
      Topic.create!(
        topic_name: "Topic Name"
      )
    ])
  end

  it "renders a list of topics" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Topic Name".to_s), count: 2
  end
end
