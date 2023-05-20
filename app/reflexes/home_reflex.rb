# frozen_string_literal: true

class HomeReflex < ApplicationReflex
  def switch_main_container
    morph "#main_container", render(partial: element.dataset["partial_path"])
    cable_ready.console_log(message: "Received from Home :: #{object}").broadcast    
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

  def save_new_object # TODO make this more generic
    topic = Topic.new(topic_name: params["topic"]["topic_name"])
    topic.user_id = current_user.id

    if topic.save
      show_notification("Topic Saved")

      morph "#topics_bar", render(partial: "home/topics_bar", locals:{ topics: current_user.topics})
      morph "#main_container", render(partial: "notes/form", locals:{ note: topic.notes.first, topic: topic })
      morph "#currentFocus", %(<input type="hidden" id="currentFocus" value="#{topic.class}::#{topic.id}" />)
    else
      show_notification("There was an Error creating the new Topic", is_error = true)
      morph "#topics_bar", "#{topic.errors.full_messages}"
    end
    # morph :nothing
  end

  def focus_on_new_topic
    # TODO save the current topic first or ask to save it.
    topic = Topic.find(element.dataset[:topic_id])
    currentFocusValue = "#{topic.class}::#{topic.id}"
    if topic.notes.last.content.empty?
      morph "#main_container", render(partial: "notes/form", locals:{ note: topic.notes.first, topic: topic, editing: true } )
    else
      morph "#main_container", render(partial: "notes/note", locals:{ note: topic.notes.last, topic: topic })
    end
    morph "#currentFocus", %(<input type="hidden" value="#{currentFocusValue}"/> )
  end

  def change
    cable_ready.console_log(message: "Received from Home").broadacast
    show_notification("Test change function")
  end
end
