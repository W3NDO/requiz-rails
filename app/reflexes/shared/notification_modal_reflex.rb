# frozen_string_literal: true

class Shared::NotificationModalReflex < ApplicationReflex

  def show_confirmation_dialog
    yet_to_implement()
    cable_ready.console_log(message: "show confirmation dialog").broadcast
    # morph :nothing
  end

  def show_dialog()
    # cable_ready.console_log(message: "=> #{JSON.parse(element.dataset["sub_locals"])}")
    cable_ready.remove_css_class(selector: "#modal_container", name: "hidden",  select_all: true ) 
    sub_locals = JSON.parse(element.dataset["sub_locals"])
    # morph :nothing
    morph "#modal_container", render( partial: "shared/dialog_modal", locals: { partial_path: element.dataset["partial_path"], sub_locals: sub_locals } )
  end

  # def show_notification
  #   is_error = element.dataset["sub_locals"]["is_error"] || false
  #   message = element.dataset["sub_locals"]["message"]
  #   # cable_ready.console_log(message: "show #{is_error ? "error" : ""} notification").broadcast

  #   morph "#notification_container", render(partial: "shared/basic_notification", locals: {message: message, is_error: is_error}) 
  # end

  def close_modal
    morph "#modal_container", ""
    cable_ready.add_css_class(selector: "#modal_container", name: "hidden")
  end
end
