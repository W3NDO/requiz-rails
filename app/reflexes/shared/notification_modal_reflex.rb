# frozen_string_literal: true

class Shared::NotificationModalReflex < ApplicationReflex

  def show_confirmation_dialog
    cable_ready.console_log(message: "show confirmation dialog").broadcast
    morph :nothing
  end

  def show_dialog
    cable_ready.console_log(message: "show dialog").broadcast
    morph :nothing
  end

  def show_notification
    is_error = element.dataset["sub_locals"]["is_error"] || false
    message = element.dataset["sub_locals"]["message"]
    # cable_ready.console_log(message: "show #{is_error ? "error" : ""} notification").broadcast

    morph "#notification_container", render(partial: "shared/basic_notification", locals: {message: message, is_error: is_error}) 
  end
end
