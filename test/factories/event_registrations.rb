FactoryGirl.define do
  factory :event_registration do
    event
    user
    agreed_to_policy true
  end
end
