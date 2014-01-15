# Be sure to restart your server when you modify this file.

if Rails.env.production?
  Geekcoffee::Application.config.session_store :redis_store, key: '_geekcoffee_session'
else
  Geekcoffee::Application.config.session_store :cookie_store, key: '_geekcoffee_session'
end


