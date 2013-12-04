class AuthenticatedController < ApplicationController
  before_filter :login_required

end
