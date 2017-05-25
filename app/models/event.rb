class Event < ApplicationRecord
  belongs_to :post

  validates :start_time, :end_time, presence:true
end
