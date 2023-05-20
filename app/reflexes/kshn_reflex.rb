# frozen_string_literal: true

class KshnReflex < ApplicationReflex
  def start_game
    cable_ready.console_log(message: "From KSHN Reflex").broadcast
    if element.dataset[:agree] == false
      show_notification("Too Bad, you have no power here.", is_error: true)
    end
    morph "#kshn-main", "Test"
  end
end
