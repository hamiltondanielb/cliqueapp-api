class Post < ApplicationRecord
  include Searchable
  include S3Credentials

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_one :event, dependent: :destroy, autosave:true
  has_one :location, through: :event

  search_scope :post_search, against: :description, associated_against: {location: [:label, :address]}

  acts_as_ordered_taggable
  validates :user, :media, presence:true
  before_destroy :ensure_no_event_before_destroying

  has_attached_file :media,
    styles: { medium: "300x300>", thumb: "100x100>" },
    processors: [ :thumbnail ],
    storage: (Rails.env.production?? :s3 : :filesystem),
    s3_credentials: Proc.new {|a| a.instance.s3_credentials},
    s3_region: ENV['S3_REGION']

  validates_attachment_content_type :media, content_type: [/\Aimage\/.*\z/]

  def self.search *args
    public.joins(:event).where.not(events_posts: {post_id: nil})
      .post_search(*args)
  end

  def self.public
    Post.joins(:user).where(users: {private: false})
  end

  def is_image?
    !! (media.content_type =~ /\Aimage/)
  end

  def prepare_tag_list
    return if tag_list.blank?
    self.tag_list = tag_list.map{|tag| tag.split(/[ ,#]/)}.flatten.select {|t| t.present?}
  end

  def like_count
    likes.count
  end

  protected
  def ensure_no_event_before_destroying
    if event.present?
      errors.add :base, "Cannot delete a post linked to an event"
      throw :abort
    end
  end
end
