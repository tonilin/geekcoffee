class API < Grape::API
  format :json

  mount Versions::V1


end