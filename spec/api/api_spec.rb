require 'spec_helper'

describe API, type: :request do
  let(:json) { JSON.parse(response.body) }
  describe API do
    describe "GET /api/hello" do
      it "returns an empty array of statuses" do
        get "/hello.json"
        response.status.should == 200
        json.should == {"hello" => "world"}
      end
    end

    describe "GET /app/version" do 
      
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