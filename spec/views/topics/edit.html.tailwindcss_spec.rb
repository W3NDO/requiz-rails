require 'rails_helper'

RSpec.describe "topics/edit", type: :view do
  let(:topic) {
    Topic.create!(
      topic_name: "MyString"
    )
  }

  before(:each) do
    assign(:topic, topic)
  end

  it "renders the edit topic form" do
    render

    assert_select "form[action=?][method=?]", topic_path(topic), "post" do

      assert_select "input[name=?]", "topic[topic_name]"
    end
  end
end
