describe User do
  it "should have auth token" do 
  	user = FactoryGirl.create(:user)
  	user.authentication_token.length.should > 3
  end
end
