require 'spec_helper'

describe API, type: :request do
  let(:json) { JSON.parse(response.body) }
  describe API do
    describe "GET /api/hello" do
      it "returns an empty array of statuses" do
        get "/hello.json"
        response.status.should == 200
        json.should == {
          "hello" => "world"
        }
      end
    end

    describe "GET /app/version" do 
      context "with higher version" do
        before {
          get 'app/version', {}, {"HTTP_USER_AGENT" => "Vingle iOS/1.0.1 (iPhone Simulator; iOS 6.1)"}
        }
        describe "response body" do
          it "should return json" do 
            json.should == {
              "current_version" => "1.0.1",
              "needs_update" => false,
              "needs_force_update" => false,
              "update_message" => "Update Message",
              "url" => "https://play.google.com/store/apps/details?id=com.daddys40"
            }
          end
        end
      end

      context "with latest version" do 
        before {
          get 'app/version', {}, {"HTTP_USER_AGENT" => "Vingle iOS/1.0.0 (iPhone Simulator; iOS 6.1)"}
        }
        describe "response body" do
          it "should return json" do 
            json.should == {
              "current_version" => "1.0.0",
              "needs_update" => false,
              "needs_force_update" => false,
              "update_message" => "Update Message",
              "url" => "https://play.google.com/store/apps/details?id=com.daddys40"
            }
          end
        end
      end

      context "with lower version" do
        before {
          get 'app/version', {}, {"HTTP_USER_AGENT" => "Vingle iOS/0.9.5b4 (iPhone Simulator; iOS 6.1)"}
        }
        describe "response body" do
          it "should return json" do 
            json.should == {
              "current_version" => "1.0.0",
              "needs_update" => true,
              "needs_force_update" => false,
              "update_message" => "Update Message",
              "url" => "https://play.google.com/store/apps/details?id=com.daddys40"
            }
          end
        end
      end      
    end

    describe "User API" do 
      describe "me APIs" do 
        describe "POST api/users/me/invitation" do 
          it "should generate invitation code" do 
            user = FactoryGirl.create(:user, email: "breath103@gmail.com")

            post "/users/me/invitation", authentication_token: user.authentication_token

            json.should == { 
              "invitation_code" => user.reload.invitation_code
            }
          end
        end

        describe "PUT update" do 
          let(:user) { FactoryGirl.create(:user, email: "breath103@gmail.com") }
          it "should update user model" do
            put "/users/me", user: { notifications_days: "012" }, authentication_token: user.authentication_token
            user.reload.notifications_days.should == "012"
            json["current_user"]["notifications_days"].should == "012"
          end
        end

        describe "DELETE me" do 
          let!(:user) { FactoryGirl.create(:user, email: "breath103@gmail.com") }
          it "should destroy user model" do
            delete "/users/me", authentication_token: user.authentication_token
            User.find_by_id(user.id).should == nil
          end
        end
      end

      describe "POST api/users" do 
        let(:now) { Time.now }
        it "should create user" do 
          post "/users", user: {
            email: "breath103@gmail.com",
            password: "123123123",
            name: "Kurt Sang Hyun Lee",
            gender: "male",
            baby_name: "Mong Mong", 
            age: 123,
            height: 171,
            weight: 52,
            notifications_days: "135",
            notificate_at: "16:40",
            baby_due: (Time.now + 6.months).to_s,
          } 
          response.should be_success
          json["current_user"]["email"].should == "breath103@gmail.com"
          json["current_user"]["notificate_at"].should == "16:40"
        end
        it "should fail for invalid data" do 
          user = FactoryGirl.create(:user, email: "breath103@gmail.com")
          post "/users", user: {
            email: "breath103@gmail.com",
            password: "123123123",
            name: "Kurt Sang Hyun Lee",
            gender: "male",
            baby_name: "Mong Mong", 
            age: 123,
            height: 171,
            weight: 52,
            notifications_days: "135",
            notificate_at: now,
            baby_due: "2014-09-09 18:39:42 +0900",
          } 
          response.status.should == 422
          json.should == {"errors" => ["Email has already been taken"] }       
        end

        context "with invitation_code" do 
          let(:user2) { FactoryGirl.create(:user) }
          before do 
            user2.generate_invitation_code
            user2.save
          end
          it "should connect other user" do 
            post "/users", user: {
              email: "breath103@gmail.com",
              password: "123123123",
              name: "Kurt Sang Hyun Lee",
              gender: "male",
              baby_name: "Mong Mong", 
              age: 123,
              height: 171,
              weight: 52,
              baby_due: "2014-09-09 18:39:42 +0900",
              notifications_days: "135",
              notificate_at: now,
              partner_invitation_code: user2.invitation_code
            } 

            response.should be_success

            user = User.find_by_email("breath103@gmail.com")

            json["current_user"]["id"].should == user.id
            json["current_user"]["partner"]["id"].should == user2.id
            user.partner_id.should == user2.id

            user2.reload
            user2.partner_id.should == user.id
          end
        end
      end

      describe "POST users/validate" do
        context "when params are valid" do 
          let!(:user) { FactoryGirl.create(:user) }
          it "should return current user" do 
            post "/users/validate", authentication_token: user.authentication_token
            response.status.should == 201
            json["current_user"]["id"].should == user.id
          end
        end 
        context "when params are invalid" do 
          it "should return current user" do 
            post "/users/validate", authentication_token: "wrong token"
            response.status.should == 401
            json.should == {"error"=>"Unauthorized"}
          end
        end 
      end
    end

    describe "Cards API" do 
      let(:user) { FactoryGirl.create(:user) }
      let!(:cards) { 
        [ FactoryGirl.create(:card, user: user),
          FactoryGirl.create(:card, user: user) ]
      }
      describe "GET me/cards" do 
        it "should return cards" do 
          get "/users/me/cards.json", authentication_token: user.authentication_token
          json.length.should == 2
          (json.collect { |card| card["id"] }).should == cards.map(&:id)
        end
      end
      describe "GET me/cards/:id" do 
        it "should return cards" do 
          cards[0].readed.should == false
          get "/users/me/cards/#{cards[0].id}.json", authentication_token: user.authentication_token
          json["id"].should == cards[0].id
          json["readed"].should == true
        end
      end
    end

    describe "Authorize API" do 
      describe "POST users/sign_in" do 
        let!(:user) { FactoryGirl.create(:user, password: "12341234") }

        it "should return user with proper email/password" do 
          post "/users/sign_in.json", user: { email: user.email, password: "12341234" }

          response.should be_success
          json["current_user"]["email"].should == user.email
        end
      end
    end
  end
end 