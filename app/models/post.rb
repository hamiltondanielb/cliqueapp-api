class Post < ApplicationRecord
  belongs_to :user
  acts_as_ordered_taggable

  validates :title, :user, presence:true

  enum difficulty_level: [:beginner, :intermediate, :expert]
end
