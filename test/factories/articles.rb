FactoryGirl.define do
  factory :article do
    user 
    title "MyString"
    body "MyText"
    published_at Time.now
  end
end
