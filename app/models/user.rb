class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  devise :omniauthable, omniauth_providers: [:facebook]

  has_many :emails, dependent: :destroy
  after_commit :save_default_email, on: :create

  belongs_to :default_email, class_name: "Email"
  validates :default_email, presence: true
  default_scope { includes :default_email }

  def email
    default_email.email rescue nil
  end

  def email= email
    self.default_email = emails.where(email: email, user: self).first_or_initialize
  end

  def self.having_email email
    User
      .joins(:emails)
      .where(emails: {
        email:  email
      })
      .first
  end

  def self.find_first_by_auth_conditions warden_conditions
    conditions = warden_conditions.dup
    if email = conditions.delete(:email)
      having_email email
    else
      super(warden_conditions)
    end
  end

  private

  def save_default_email
    default_email.user = self
    default_email.save!
  end

end
