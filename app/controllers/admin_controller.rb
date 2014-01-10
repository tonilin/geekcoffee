class AdminController < ApplicationController
  before_filter :login_required
  before_filter :require_is_admin
  
end
