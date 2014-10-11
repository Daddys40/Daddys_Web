object @user

node :current_user do |user|	
	partial("users/user", :object => user) 
end