class PagesController < HighVoltage::PagesController


  def welcome
    render :layout => "landing"
  end

end
