# frozen_string_literal: true

class HomeReflex < ApplicationReflex
  def new_object_view
    model = element.dataset["model"]
    object = get_object(model)
    morph "#main_container", render(partial: element.dataset[:partial_path], locals: { model.downcase.singularize => object })
  end

  def save_new_object
    model = element.dataset["model"]
    log(params[model])
    object = get_object(model).new(sanitize_params(model, params))
    object.user_id = current_user.id
    log(object.persisted?)

    if object.save
      # object.quiz_file.attach(params[model]["quiz_file"]) if model == "quiz"
      show_notification("#{model.titleize} Saved")
      morph "#selection_bar", render(
        partial: "home/selection_bar",
        locals: {
          :model => model.singularize,
        }
      )
      morph "#selection_bar_mobile", render(
        partial: "home/selection_bar",
        locals: {
          :model => model.singularize,
          :mobile => true
        }
      )
      morph "#main_container", render(
        partial: "#{model.pluralize.downcase}/#{model.downcase}",
        locals:{
          model.to_sym => object
        }
      )
      # morph "#currentFocus", %(<input type="hidden" id="currentFocus" value="#{topic.class}::#{topic.id}" />)
    else
      show_notification("There was an Error creating the new #{model.titleize}", is_error = true)
      morph "#selection_bar", "#{object.errors.full_messages}"
      morph "#selection_bar_mobile", "#{object.errors.full_messages}"
    end
    # morph :nothing
  end

  def alter_main_container_content
    model = element.dataset["model"].downcase
    if model == "home"
      morph "#main_container", render(partial: "home/landing", locals: {})
    else
      # object = get_object(model).find(element.dataset["id"])
      objects = User.find(element.dataset[:uid]).public_send(model.pluralize.to_sym)
      morph "#main_container", render(
          partial: "#{model.pluralize.downcase}/landing",
          locals:{
            model.pluralize.to_sym => objects
          }
        )
    end
  end

  def alter_sidebar
    model = element.dataset[:model]
    morph "#selection_bar", render(partial: "home/selection_bar", locals:{model: model})
    morph "#selection_bar_mobile", render(partial: "home/selection_bar", locals:{model: model, mobile: true})
  end

  private
  def get_object(model)
    model = model.singularize
    allowed_objects = [Topic, Subtopic, Quiz]
    allowed_objects.select{ |obj| model.classify == obj.to_s }.first
  end

  def sanitize_params(model, params)
    allowed_params = {
      :quiz => [:tag, :title, :quiz_file],
      :topic => [:title]
    }
    params.require(model.to_sym).permit(*allowed_params[model.to_sym])
  end
end
