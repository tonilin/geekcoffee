class Entities::User < Grape::Entity
  expose :id, :name, :authentication_token
end