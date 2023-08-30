class HomeController < ApplicationController
  def index
    @topics = current_user.topics if current_user.present? 
  end
end
