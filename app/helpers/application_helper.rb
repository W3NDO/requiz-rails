module ApplicationHelper
  NAVBAR_MENU_OPTIONS = {
    :home => :root_path,
    :quiz => :quizzes_path
  }

  NAVBAR_AUTH_OPTIONS = {
    :login => :new_user_session_path,
    :register => :new_user_registration_path
  }
end
