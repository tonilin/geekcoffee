class APIController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout :nil
  


end
