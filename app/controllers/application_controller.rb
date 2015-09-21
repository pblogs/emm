class ApplicationController < ActionController::API
  acts_as_jwt_authentication_handler
  include CanCan::ControllerAdditions
  include FrontendHelper

  respond_to :json
end
