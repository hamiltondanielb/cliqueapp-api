class Article < ApplicationRecord
  belongs_to :user

  def draft?
    !published?
  end

  def published?
    published_at.present?
  end
end
