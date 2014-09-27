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

        describe "Partner APIs" do 
          let(:user) { FactoryGirl.create(:user) }
          let(:user2) { FactoryGirl.create(:user) }
          before do 
            user2.generate_invitation_code
            user2.save
          end
          it "should connect other user" do 
            post "/users/me/partner", authentication_token: user.authentication_token, invitation_code: user2.invitation_code
            user.reload
            user2.reload

            user.partner_id.should == user2.id
            user2.partner_id.should == user.id
          end
        end
      end

      describe "POST api/users" do 
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
            baby_due: "2014-09-09 18:39:42 +0900",
          } 
          response.should be_success
          json["current_user"]["email"].should == "breath103@gmail.com"
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
            baby_due: "2014-09-09 18:39:42 +0900",
          } 
          response.status.should == 422
          json.should == {"errors" => ["Email has already been taken"] }       
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
            json.should == {}
          end
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