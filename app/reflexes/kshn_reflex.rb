# frozen_string_literal: true

class KshnReflex < ApplicationReflex

  def start_game
    
    cable_ready.console_log(message: "From KSHN Reflex :: #{element.dataset["agree"]}").broadcast
    if element.dataset["agree"] == "false"
      show_notification("Too Bad, you have no power here.")
    end
    morph "#current_question", "q1"
    morph "#kshn-main", render(partial: "kshn/card1", locals: {})
  end

  def mark1
    if element.dataset["answer"] == "2013" 
      morph "#kshn-main", render(partial: "kshn/card2", locals: {}) 
      morph "#error", ""
    else 
      morph "#error", "Wrong. Try Again"
    end 
  end
  
  def mark2
    if element.dataset["answer"] == "VISUAL BASIC"
      morph "#kshn-main", render(partial: "kshn/card3", locals: {})
      morph "#error", ""
    else 
      morph "#error", "Wrong. Try Again"
    end
  end
  
  def mark3
    if element.dataset["answer"] == "Pong with p5.js"
      morph "#kshn-main", render(partial: "kshn/card4", locals: {}) 
      morph "#error", ""
    else 
      morph "#error", "Wrong. Try Again"
    end
  end
  
  def mark4
    if element.dataset["answer"] == "FL 11" 
      morph "#kshn-main", render(partial: "kshn/final_screen", locals: {}) 
      morph "#error", ""
    else 
      morph "#error", "Wrong. Try Again"
    end
  end

  def check
    cable_ready.set_dataset_property(
      selector: ".nextBtn",
      name: "answer",
      value: element.dataset["answer"]
    )
    morph :nothing
  end

  def highlight
    # cable_ready.add_css
    morph :nothing
  end
end
