class Post < ApplicationRecord
  belongs_to :user
  include S3Credentials
  acts_as_ordered_taggable

  validates :user, :media, presence:true
  has_many :likes, dependent: :destroy
  has_one :event, dependent: :destroy

  has_attached_file :media,
    styles: lambda { |a| a.instance.is_image? ?
      { medium: "300x300>", thumb: "100x100>" } :
      {
        :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 },
        :mp4 => { :format => "mp4", convert_options: {
          output: {
            'c:v' => 'copy',
            'c:a' => 'copy'
          }
        }}
      }
    },
    processors: lambda { |a| a.is_video? ? [ :transcoder ] : [ :thumbnail ] },
    storage: (Rails.env.production?? :s3 : :filesystem),
    s3_credentials: Proc.new {|a| a.instance.s3_credentials},
    s3_region: ENV['S3_REGION']

  validates_attachment_content_type :media, content_type: [/\Aimage\/.*\z/, /\Avideo\/.*\z/]

  def is_image?
    !! (media.content_type =~ /\Aimage/)
  end

  def is_video?
    !! (media.content_type =~ /\Avideo/)
  end

  def prepare_tag_list
    return if tag_list.blank?
    self.tag_list = tag_list.map{|tag| tag.split(/[ ,#]/)}.flatten.select {|t| t.present?}
  end

  def like_count
    likes.count
  end
end
