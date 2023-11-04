class User < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_events, through: :likes, source: :event

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: /\S+@\S+/ }, 
                    uniqueness: {case_sensitive: false}

# By setting the allow_blank option to true, the length validation won't run if the password field is blank. That's important because a password isn't required when a user updates his name and/or email.
validates :password,length: {minimum: 6, allow_blank: true}
end
