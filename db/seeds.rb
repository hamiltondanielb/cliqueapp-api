# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

I18n.locale = :en

ActiveRecord::Base.transaction do

  ['al', 'ed', 'eric', 'bob', 'Mickey'].each do |username|
    user = User.create! name: username, email: "#{username}@example.org", password:'12345678', password_confirmation:'12345678', instructor_terms_accepted:true
    user.skip_confirmation!
    user.save!
  end

  10.times do |n|
    Post.create! user: User.all.sample, description: "test post #{n}", media_file_name: "test.png", media_file_size:0
  end

  5.times do |n|
    start_time = [-3,-2,-1,0,1,2,3].sample.days.from_now
    end_time = start_time + 2.hours
    Post.create! user: User.all.sample, description: "my event #{n}", media_file_name: "test.png", media_file_size: 0, event: Event.new(start_time:start_time, end_time:end_time, location: Location.new(label:'there'))
  end

end
