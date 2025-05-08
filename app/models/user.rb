class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # validates presence so blank fields are avoided
  validates :email_address, presence: true
  validates :password, presence: true, confirmation: true
  
  after_initialize do
    self.role ||= 'customer' if self.new_record?
  end
end
