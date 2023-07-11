class Api::V1::ApplicationController < ::ApplicationController
  include DeviseTokenAuth::Concers::SetUserByToken
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
end