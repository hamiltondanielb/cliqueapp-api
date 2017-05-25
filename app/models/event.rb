class Event < ApplicationRecord
  belongs_to :post

  validates :date, :time, presence:true
end
