# frozen_string_literal: true

class QuizReflex < ApplicationReflex
  
  def add_questions
    quiz = Quiz.find(element.dataset["id"]) || Quiz.new
    morph "#quiz_main", render(
      partial: "quizzes/form", 
      :locals => {
        :object => quiz
      }
    )
  end

  def start_quiz
    # TODO :: add sounds??
    # cable_ready.add_css_class(selector: "#start_btn", name: "is-disabled")
    # cable_ready.set_attribute(selector: "#start_btn", name: "disabled", value: true)
    # cable_ready.remove_css_class(selector: "#start_btn", name: "is-primary")

    questions = Quiz.includes(:questions).find(element.dataset[:id]).questions
    question_count = questions.length
    correct_answer_count = 0
    next_index = 1
    my_answers = []
    morph "#main_container", render(partial: "quizzes/question", locals: {
      :question => questions.first, 
      :question_count => question_count,
      :correct_answer_count => correct_answer_count,
      :order => questions.map{ |k| k[:id] }.join(","),
      :next_index => next_index,
      :my_answers => my_answers,
    })
    morph "#counter", "#{correct_answer_count}/#{question_count}"

  end

  def check_answer
    has_next = element.dataset["order"].split(",").last != element.dataset["qid"]
    question = Question.find_by(id: element.dataset["qid"])
    quiz = question.quiz
    questions = quiz.questions
    order = element.dataset["order"]
    next_index = element.dataset["next_index"].to_i
    
    is_correct = element.dataset["ans"] == question.answer.chomp
    if is_correct
      correct_answer_count = element.dataset["correct_answer_count"].to_i + 1
    else 
      correct_answer_count = element.dataset["correct_answer_count"].to_i
    end
    
    if has_next
      cable_ready.add_css_class(selector: "#start_btn", name: "is-disabled")
      cable_ready.set_attribute(selector: "#start_btn", name: "disabled", value: true)
      cable_ready.remove_css_class(selector: "#start_btn", name: "is-primary")
      next_question = questions[next_index]
      next_index += 1
      morph "#main_container", render(partial: "quizzes/question", locals: {
        :question => next_question, 
        :question_count => questions.length,
        :correct_answer_count => correct_answer_count,
        :order => questions.map{ |k| k[:id] }.join(","),
        :my_answers => element.dataset["my_answers"],
        :next_index => next_index
      })
      morph "#counter", "#{correct_answer_count}/#{questions.length}"
    else 
      cable_ready.add_css_class(selector: "#start_btn", name: "is-primary")
      cable_ready.remove_attribute(selector: "#start_btn", name: "disabled")
      cable_ready.remove_css_class(selector: "#start_btn", name: "is-disabled")
      score = ((correct_answer_count.to_f/questions.length.to_f)*100).round(2)
      quiz.update!(score: score) # Update quize with the last score they got

      morph "#main_container", render(partial: "quizzes/end_of_quiz", locals: {
        :quiz => question.quiz,
        :question_count => questions.length,
        :correct_answer_count => correct_answer_count,
      })
    end
  end

end
