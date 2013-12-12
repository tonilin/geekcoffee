class AdminController < ApplicationController
  before_filter :require_is_admin
  
end
