# frozen_string_literal: true

class FlashcardReflex < ApplicationReflex
  def start_flash_session
    cable_ready.add_css_class(selector: "#start_btn", name: "is-disabled")
    cable_ready.set_attribute(selector: "#start_btn", name: "disabled", value: true)
    cable_ready.remove_css_class(selector: "#start_btn", name: "is-primary")
    cable_ready.add_css_class(selector: "#flash_btn", name: "is-disabled")
    cable_ready.set_attribute(selector: "#flash_btn", name: "disabled", value: true)
    cable_ready.remove_css_class(selector: "#flash_btn", name: "is-warning")

    flashcards = Quiz.find(element.dataset["id"]).flashcards
    morph "#quiz_main", render(:partial => "quizzes/flashcard", :locals => {:flashcards => flashcards } )
    # morph :nothing
  end
end
