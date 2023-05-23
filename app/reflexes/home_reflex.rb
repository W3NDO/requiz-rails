# frozen_string_literal: true

class HomeReflex < ApplicationReflex
  include ActiveSupport::Inflector

  def switch_main_container
    morph "#main_container", render(partial: element.dataset["partial_path"])
    cable_ready.console_log(message: "Received from Home :: #{object}").broadcast    
  end

  def new_object_view
    model = element.dataset["model"]
    object = get_object(model)
    morph "#main_container", render(partial: element.dataset[:partial_path], locals: { model.downcase.singularize.to_sym => object })
  end

  def save_new_object # TODO make this more generic
    model = element.dataset["model"]
    object = get_object(model).new
    params[model].each do |k,v|
      object[k.to_sym] = v
    end
    object.user_id = current_user.id
    cable_ready.console_log( message: object )

    if object.save
      show_notification("#{model.titleize} Saved")
      morph "#selection_bar", render(
        partial: "home/selection_bar", 
        locals: { 
          :model => model.singularize, 
          model.pluralize.to_sym => current_user.public_send(model.pluralize.to_sym) 
        } 
      )
      morph "#main_container", render(
        partial: "#{model.pluralize.downcase}/form", 
        locals:{ 
          object => object,
        }
      )
      # morph "#currentFocus", %(<input type="hidden" id="currentFocus" value="#{topic.class}::#{topic.id}" />)
    else
      show_notification("There was an Error creating the new Topic", is_error = true)
      morph "#selection_bar", "#{topic.errors.full_messages}"
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

  def alter_sidebar
    model = element.dataset[:model]
    morph "#selection_bar", render(partial: "home/selection_bar", locals:{model: model})
  end

  def change
    cable_ready.console_log(message: "Received from Home").broadacast
    show_notification("Test change function")
  end

  private
  def get_object(model)
    allowed_objects = [Topic, Subtopic, Quiz]
    allowed_objects.select{ |obj| model.classify == obj.to_s }.first
  end
end
