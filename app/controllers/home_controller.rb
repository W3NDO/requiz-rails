class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @topics = current_user.topics
  end
end
