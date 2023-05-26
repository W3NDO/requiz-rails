# frozen_string_literal: true

class ApplicationReflex < StimulusReflex::Reflex
  # Put application-wide Reflex behavior and callbacks in this file.
  #
  # Learn more at: https://docs.stimulusreflex.com/guide/reflex-classes
  #
  # If your ActionCable connection is: `identified_by :current_user`
  #   delegate :current_user, to: :connection
  #
  # current_user delegation allows you to use the Current pattern, too:
  #   before_reflex do
  #     Current.user = current_user
  #   end
  #
  # To access view helpers inside Reflexes:
  #   delegate :helpers, to: :ApplicationController
  #
  # If you need to localize your Reflexes, you can set the I18n locale here:
  #
  #   before_reflex do
  #     I18n.locale = :fr
  #   end
  #
  # For code examples, considerations and caveats, see:
  # https://docs.stimulusreflex.com/guide/patterns#internationalization
  delegate :current_user, to: :connection

  def show_notification(message, is_error=false)
    morph "#notification_container", render(partial: "shared/basic_notification", locals: {message: message, is_error: is_error}) 
  end

  def show_modal(partial_path, sub_locals)
    cable_ready.remove_css_class(selector: "#modal_container", name: "hidden",  select_all: true ) 
    # sub_locals = JSON.parse(element.dataset["sub_locals"])
    morph "#modal_container", render( partial: "shared/dialog_modal", locals: { partial_path: partial_path, sub_locals: sub_locals } )
  end
  
  def yet_to_implement
    show_notification("You caught me. This is yet to be implemented", is_error=true)
  end
end
