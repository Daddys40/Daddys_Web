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
              "url" => "https://play.google.com/store/apps/details?id=com.daddys40&hl=ko"
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
              "url" => "https://play.google.com/store/apps/details?id=com.daddys40&hl=ko"
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
              "url" => "https://play.google.com/store/apps/details?id=com.daddys40&hl=ko"
            }
          end
        end
      end      
    end

    describe "User API" do 
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