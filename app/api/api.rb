class API < Grape::API
  format :json
  default_format :json
  content_type :json, "application/json; charset=utf-8"

  HTTP_ERROR_CODE = 422

  get 'hello' do
    return { hello: "world" }
  end


  helpers do
    def warden
      env['warden']
    end

    def authenticate!
      return true if warden.authenticated? || current_user
      params[:authentication_token] && @user = User.find_by_authentication_token(params[:authentication_token])
    end

    def current_user
      return @current_user if @current_user 
      return @current_user = (warden.user || @user)
    end

    def agent_version(agent)
      return agent unless agent
      components = agent.split(" ")
      if components.length > 2
        return components[1].split("/")[1]
      end
      return nil;
    end

     def is_request_from_ios?
      user_agent = request.env["HTTP_USER_AGENT"]
      user_agent and (user_agent.include?("iPhone") or user_agent.include?("iPod") or user_agent.include?("iPad"))
    end

    def is_request_from_android?
      user_agent = request.env["HTTP_USER_AGENT"]
      user_agent && user_agent.include?("Android")
    end
  end


  namespace :app do 
    get :version do
      user_current_version = agent_version(request.env["HTTP_USER_AGENT"])

      latest_version = "1.0.0"

      needs_update = false
      current_version = (
        if user_current_version && user_current_version >= latest_version
          user_current_version
        else
          needs_update = true
          latest_version
        end
      )

      return {
        current_version: current_version,
        update_message: "Update Message",
        needs_update: needs_update,
        needs_force_update: false,
        url: "https://play.google.com/store/apps/details?id=com.daddys40"
      } 
    end

    get :install do 
      if is_request_from_android? 
        redirect("https://play.google.com/store/apps/details?id=com.daddys40")
      elsif is_request_from_ios?
        "Sorry. iOS app is comming soon"
      else
        "Sorry. app is not supported on your platform"
      end
    end
  end

  namespace "users/validate" do 
    post do
      authenticate!
      if current_user 
        { 
          current_user: current_user.public_hash
        }
      else
        status 401
        {}
      end
    end
  end

	namespace "users" do 
    desc "Query users"
    get do 
      User.all
    end

    params do 
      requires :id, type: Integer
    end
    namespace ":id" do
      before do 
        @user = User.find_by_id(params[:id])
      end
    end

    namespace "me" do 
      before do 
        authenticate!
      end

      namespace "questions" do 
        get do 
          "!!!!"
        end

        get "new" do 
          redirect "/users/me/questions"
          # if user.new_question 
          # else 
          #   error!({errors: ["no more questions for this week"] }, 404)
          # end
        end
      end

      namespace "cards" do 
        get do 
          return {
            data: [
              {
                id: 1,
                title: "Some Title", 
                week: 15,
                content: "asldjghsajlgsdghjsdlf lksdajfhdk fhsfljkshdl kfhlsadjkhsdjaklfhlsadkj fadhsjf sjfkl dskjfhsjkda fljksadfk lalfkhsaldjk fhsdafas df",
                resources: [
                  {
                    type: "image",
                    width: 320,
                    height: 200,
                    image_url: "http://cfile30.uf.tistory.com/image/21769F46533A841516123F"
                  }
                ]
              },
              {
                id: 2,
                title: "Some ㅎㄴㅇㅎㅁㄴㅎㄴㅇㅎ", 
                week: 15,
                content: "asldjghsajlgsdghjsdlf lksdajfhdk fhsfljkshdl kfhlsadjkhsdjaklfhlsadkj fadhsjf sjfkl dskjfhsjkda fljksadfk lalfkhsaldjk fhsdafas df",
                resources: [
                  {
                    type: "image",
                    width: 320,
                    height: 200,
                    image_url: "http://scbbs3.sportschosun.com/Pds/Board/funfum04/%EC%8B%A4%EC%A1%B4%ED%95%98%EB%8A%94_%EC%BD%9C%EB%9D%BC%EB%B3%91_%EB%AA%B8%EB%A7%A4_%EC%A0%9C%EB%8B%88%ED%8D%BC%EB%A1%9C%EB%A0%8C%EC%8A%A41.jpg"
                  }
                ]
              },
              {
                id: 3,
                title: "Some ㅎㄴㅇㅎㅁㄴㅎㄴㅇㅎ", 
                week: 15,
                content: "asldjghsajlgsdghjsdlf lksdajfhdk fhsfljkshdl kfhlsadjkhsdjaklfhlsadkj fadhsjf sjfkl dskjfhsjkda fljksadfk lalfkhsaldjk fhsdafas df",
                resources: [
                  {
                    type: "image",
                    width: 320,
                    height: 200,
                    image_url: "http://scbbs3.sportschosun.com/Pds/Board/funfum04/%EC%8B%A4%EC%A1%B4%ED%95%98%EB%8A%94_%EC%BD%9C%EB%9D%BC%EB%B3%91_%EB%AA%B8%EB%A7%A4_%EC%A0%9C%EB%8B%88%ED%8D%BC%EB%A1%9C%EB%A0%8C%EC%8A%A41.jpg"
                  }
                ]
              }
            ] 
          }
        end

        get ":id" do 
          return {
            id: 1,
            title: "Some Title", 
            week: 15,
            content: "asldjghsajlgsdghjsdlf lksdajfhdk fhsfljkshdl kfhlsadjkhsdjaklfhlsadkj fadhsjf sjfkl dskjfhsjkda fljksadfk lalfkhsaldjk fhsdafas df",
            resources: [
              {
                type: "image",
                width: 320,
                height: 200,
                image_url: "http://cfile30.uf.tistory.com/image/21769F46533A841516123F"
              }
            ]
          }
        end
      end

      post "invitation" do
        current_user.generate_invitation_code
        current_user.save
        return {
          invitation_code: current_user.invitation_code
        }
      end
    end
  end
end
