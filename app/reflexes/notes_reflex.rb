# frozen_string_literal: true

class NotesReflex < ApplicationReflex 
  def update_title
    show_notification("Yet to implement", is_error=true)
  end

  def save_note
    cable_ready.console_log(message: "#{params} :: #{element.dataset["topic_id"]}")
    note = Note.new(topic_id: element.dataset["topic_id"], content: params["content"])
    if note.save
      show_notification("Notes saved  &#x263A;")
      morph "#main_container", render(partial: "notes/note", locals:{ note: note, topic: Topic.find(element.dataset["topic_id"]) })
    else
      show_notification("There was an issue saving your note. Please try again", is_error=true)
      morph :nothing
    end
  end
end
