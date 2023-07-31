# frozen_string_literal: true

class DocsReflex < ApplicationReflex
  before_reflex :set_sections, only: [:show_docs]

  def show_docs
    # TODO show navigation on selection_bar.
    # TODO render documentation on main container. 
    
    morph "#selection_bar", render(:partial => "docs/docs_nav", :locals => {sections: @sections, mobile: false})
    morph "#selection_bar_mobile", render(:partial => "docs/docs_nav", :locals => {sections: @sections, mobile: true})
    morph "#main_container", render(:partial => "docs/#{@sections[0]}", :locals => {})
    # morph :nothing
  end

  def focus_on_docs_section
    section = element.dataset["section"]
    morph "#main_container", render(:partial => "docs/#{section}", :locals => {})
  end

  private
  def set_sections
    # the order of sections here determines the order they will be in the Nav bar. 
    @sections = [ :introduction, :quiz, :csv ]
  end

end
