describe User do
  let(:user) { FactoryGirl.create(:user) }
  it "should have auth token" do 
  	user.authentication_token.length.should > 3
  end
end
