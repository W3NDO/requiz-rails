# frozen_string_literal: true

class TimerReflex < ApplicationReflex
  def toggle_times
    show_modal("home/timer_options", {})
  end
end
