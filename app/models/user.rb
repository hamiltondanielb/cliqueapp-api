class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :lockable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, presence:true

  has_attached_file :profile_picture, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\z/

  protected
     def confirmation_required?
       false
     end
end
