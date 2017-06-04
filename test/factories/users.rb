FactoryGirl.define do
  factory :user do
    sequence :name do |n|
      "Mr Tester #{n}"
    end
    sequence :email do |n|
      "tester#{n}@example.org"
    end
    sequence :jti do |n|
      "70b3f738-26dc-4d4d-a26d-530bbb39364#{n}"
    end

    password '12345678'
    encrypted_password Devise::Encryptor.digest(User, '12345678')
    confirmed_at 1.day.ago
    instructor_terms_accepted true
  end
end
