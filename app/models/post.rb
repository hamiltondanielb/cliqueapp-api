class Post < ApplicationRecord
  belongs_to :user
  acts_as_ordered_taggable

  validates :user, :media, presence:true

  has_attached_file :media,
    styles: lambda { |a| a.instance.is_image? ?
      { medium: "300x300>", thumb: "100x100>" } :
      { :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }}},
    processors: lambda { |a| a.is_video? ? [ :transcoder ] : [ :thumbnail ] }

  validates_attachment_content_type :media, content_type: [/\Aimage\/.*\z/, /\Avideo\/.*\z/]

  def is_image?
    !! (media.content_type =~ /\Aimage/)
  end

  def is_video?
    !! (media.content_type =~ /\Avideo/)
  end

end
