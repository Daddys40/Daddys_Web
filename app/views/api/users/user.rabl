object @user

attributes :id
attributes :email
attributes :updated_at
attributes :name
attributes :role, :gender, :baby_name, :age, :height, :weight, :baby_due, :authentication_token, :invitation_code, :notifications_days, :notificate_at

node(:created_at) { |u| u.created_at.to_s }
