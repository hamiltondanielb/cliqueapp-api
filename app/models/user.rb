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
                    s3_credentials: Proc.new {|a| a.instance.s3_credentials }
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\z/

  has_many :posts, dependent: :destroy

end
