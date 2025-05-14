class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # validates presence so blank fields are avoided
  validates :email_address, presence: true
  validates :password, presence: true, confirmation: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  
  after_initialize do
    self.role ||= 'customer' if self.new_record?
  end

  # Display full name
  def full_name
    "#{first_name} #{last_name}".strip
  end

end
