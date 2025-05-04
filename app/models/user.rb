class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_initialize do
    self.role ||= 'customer' if self.new_record?
  end
end
