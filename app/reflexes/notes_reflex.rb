# frozen_string_literal: true

class NotesReflex < ApplicationReflex
  def update_title
    show_notification("Yet to implement", is_error=true)
  end
end
