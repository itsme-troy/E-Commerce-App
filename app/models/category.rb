class Category < ApplicationRecord
    # a category can have many products 
    # if category is deleted, its products will not be deleted, 
    has_many :products, dependent: :nullify
  
    validates :name, presence: true
end