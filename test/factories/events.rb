FactoryGirl.define do
  factory :event do
    post
    price 0
    start_time 2.days.from_now
    end_time 3.days.from_now
  end
end
