FactoryGirl.define do
  factory :user do
    name "Test User"
    email { Faker::Internet.email }
    password "please123"

  	gender User::GENDER.MALE
  	baby_name "Mong Mong"
  	age 124
  	height 124
  	weight 123
  	baby_due Time.now
    notifications_days "135"
    notificate_at Time.now
    trait :admin do
      role 'admin'
    end
  end
end
