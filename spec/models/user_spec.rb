describe User do
  let(:user) { FactoryGirl.create(:user) }
  it "should have auth token" do 
  	user.authentication_token.length.should > 3
  end

  describe ".generateInvitationCode" do
  	it "should generate invitation code" do 
	  	user.invitation_code.should == nil

	  	user.generate_invitation_code

	  	user.invitation_code.length.should == 4
  	end
  end
end
