class API < Grape::API
  format :json

  mount Versions::V1

    before do
      header "Access-Control-Allow-Origin", "*"
      header "Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT"
      header "Access-Control-Max-Age", "1728000"
    end



  add_swagger_documentation :hide_documentation_path => true, :api_version => "v1", :base_path => "http://geekcoffee.roachking.net/api"

end