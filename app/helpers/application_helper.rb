module ApplicationHelper

  def notice_message
    flash_messages = []
    flash.each do |type, message|
      type = :success if type == :notice
      type = :danger if type == :alert
      text = content_tag(:div, link_to("x", "#", :class => "close", "data-dismiss" => "alert") + message, :class => "alert fade in alert-#{type}")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end

  def render_site_name
    Setting.app_name
  end

  def render_facebook_icon(user)
    # Using the graph api endpoint: http://developers.facebook.com/docs/api
    if user.fb_id
      image_tag("http://graph.facebook.com/#{user.fb_id}/picture?width=30&height=30", :class => "avatar", :alt => user.name, :title => user.name)
    end
  end


end
