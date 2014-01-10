class API < Grape::API
  format :json

  mount Versions::V1




  add_swagger_documentation :hide_documentation_path => true, :api_version => "v1", :base_path => "#{ENV["BASE_URL"]}/api"

end