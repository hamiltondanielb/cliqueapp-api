FactoryGirl.define do
  factory :post do
    user
    sequence :description do |n|
      "test description ##{n}"
    end
    media_file_name "test.png"
    media_file_size "1024"
  end
end
