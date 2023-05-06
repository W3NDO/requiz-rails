# frozen_string_literal: true

class HomeReflex < ApplicationReflex
  def switch_main_container
    morph "#main_container", render(partial: element.dataset["partial_path"])
  end

  def new_object_view
    new_objects = {
      "topic" => Topic,
      "subtopic" => Subtopic,
    }

    object = new_objects[element.dataset["model"]].public_send(:new)
    cable_ready.console_log(message: "Received from Home :: #{object}").broadcast    
    morph "#main_container", render(partial: element.dataset[:partial_path], locals: { element.dataset["model"].to_sym => Topic.new })
  end

  def save_new_object
    cable_ready.console_log(message: "<< #{params} >>").broadcast


    topic = Topic.new(topic_name: params["topic"]["topic_name"])
    topic.user_id = current_user.id

    cable_ready.console_log(message: "Topic: #{topic.errors.full_messages }").broadcast
    if topic.save
      morph "#topics_bar", render(partial: "home/topics_bar", locals:{ topics: current_user.topics})
      morph "#main_container", ""
    else
      morph "#topics_bar", "#{topic.errors.full_messages}"
    end
    # morph :nothing
  end

  def change
    cable_ready.console_log(message: "Received from Home")
    morph "#main_container", "Your muscles... they are so tight."
  end
end
