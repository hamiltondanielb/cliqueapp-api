class User < ApplicationRecord
  include S3Credentials
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :lockable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, presence:true

  has_attached_file :profile_picture, styles: { medium: "300x300>", thumb: "100x100>" },
                    storage: (Rails.env.production?? :s3 : :filesystem),
                    s3_credentials: Proc.new {|a| a.instance.s3_credentials },
                    s3_region: ENV['S3_REGION']

  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\z/

  has_many :posts, dependent: :destroy
  has_many :follows, dependent: :destroy, class_name: 'Follow', foreign_key: :follower_id
  has_many :followers, dependent: :destroy, class_name: 'Follow', foreign_key: :followed_id
  has_many :following_users, through: :follows, source: :followed
  has_many :follower_users, through: :followers, source: :follower
  has_many :likes
  has_many :event_registrations
  has_many :events, through: :event_registrations

  def active_events
    Event.joins(:event_registrations).where('event_registrations.cancelled_at':nil).where('event_registrations.user_id': self.id)
  end

  def following_count
    follows.count
  end

  def follower_count
    followers.count
  end

  def event_count
    organized_events.active.count
  end

  def organized_events
    Event.joins(:post).where('posts.user_id' => id)
  end

  def home_feed
    Post.order('created_at DESC').where('user_id in (?)', follows.map(&:followed_id)).limit(20)
  end
end
