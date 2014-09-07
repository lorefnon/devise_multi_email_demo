class UserIdentity < ActiveRecord::Base
  belongs_to :user
  belongs_to :email
  validates :user, :email, :uid, :provider, presence: true
end
