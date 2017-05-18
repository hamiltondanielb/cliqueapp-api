class Post < ApplicationRecord
  belongs_to :user

  validates :title, :user, presence:true

  enum difficulty_level: [:beginner, :intermediate, :expert]
end
