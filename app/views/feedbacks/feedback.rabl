object @feedback

attributes :id
attributes :text
node(:created_at) { |u| u.created_at.to_s }
node(:user) { |feedback| 
	user = feedback.user
	{ 
		id: user.id,
		email: user.email
	}
}  
