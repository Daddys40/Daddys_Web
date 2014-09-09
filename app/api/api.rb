class API < Grape::API
  get 'hello' do
    return { hello: "world" }
  end

# /oauth/authorize/:code
# GET       /oauth/authorize
# POST      /oauth/authorize
# PUT       /oauth/authorize
# DELETE    /oauth/authorize
  namespace :auth do 
  	namespace :authorize do 
  		get do 
  		end
  	end
  end
end
