object @user

attributes :id
attributes :email
node(:created_at) { |u| u.created_at.to_s }
node(:updated_at) { |u| u.created_at.to_s }
attributes :name
attributes :role
attributes :gender
attributes :baby_name
attributes :age
attributes :height
attributes :weight
node(:baby_due) { |u| u.baby_due.to_s }
attributes :authentication_token
attributes :invitation_code
attributes :notifications_days
attributes :notificate_at
node(:notificate_at) { |u| u.notificate_at.to_s(:time) }

if locals[:show_partner]
	node(:partner, :if => lambda { |u| u.partner }) { |user| 
		partial("users/user", :object => user.partner) 
	}  
end