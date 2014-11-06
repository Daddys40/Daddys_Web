class API < Grape::API
  format :json
  default_format :json
  formatter :json, Grape::Formatter::Rabl  
  content_type :json, "application/json; charset=utf-8"

  HTTP_ERROR_CODE = 422

  helpers do
    def declared_params
      declared(params, include_missing: false)
    end

    def warden
      env['warden']
    end

    def not_found?(model)
      error!({error: "Not Found "}, 404) unless model
    end

    def authenticate!
      return true if @current_user
      @current_user ||= User.find_by_authentication_token(params[:authentication_token]) if params[:authentication_token]
      @current_user ||= warden.user 
      error!({error: "Unauthorized"}, 401) unless @current_user
    end

    def current_user
      return @current_user
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
    post "", rabl: "users/auth" do
      authenticate!
      @user = current_user
    end
  end

	namespace "users" do 
    desc "Query users"

    params do 
      requires :page, type: Integer, default: 1
      requires :count, type: Integer, default: 30
    end
    get "", rabl: "users/users" do 
      @users = User.page(params[:page]).per(params[:count])
    end

    get "total_metric" do 
      combination_count = User.group(:notifications_days).count
      days = {
        0 => 0,
        1 => 0,
        2 => 0,
        3 => 0,
        4 => 0,
        5 => 0,
        6 => 0
      }
      combination_count.each do |combination, count| 
        combination.each_char do |day_s| 
          days[day_s.to_i] += count
        end
      end

      {
        count: User.count,
        notifications_days: days,
        notificate_at: User.group("DATE_PART('hour', notificate_at)").count
      }
    end

    params do 
      optional :range, type: Integer, default: 1
    end 
    get "count_chart" do 
      User.group("DATE_PART('hour',created_at)")
          .where("created_at > ?", Time.now - params[:range].day)
          .count
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

      put "", rabl: "users/auth" do 
        authenticate!
        current_user.update_attributes(params[:user].to_h)
        @user = current_user
      end

      delete do 
        authenticate!
        if current_user.destroy
          { success: true }
        else 
          error!( { error: current_user.errors.full_messages}, 422)
        end
      end

      namespace "cards" do 
        get "", rabl: "cards/cards" do
          if params[:week] && params[:count]
            week  = params[:week].to_i
            count = params[:count].to_i
            data = QuestionSheet.normal_data(current_user.gender, week, count)
            current_user.cards.create({ 
              title: data[:title], 
              content: data[:content], 
              week: week, 
              resources_count: 0 
            })
          end
          @cards = current_user.cards.order("created_at DESC")
        end

        namespace ":id" do 
          get "", rabl: "cards/card" do 
            @card = current_user.cards.find_by_id(params[:id])
            @card.update_attribute(:readed, true)
            not_found?(@card)
          end
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
