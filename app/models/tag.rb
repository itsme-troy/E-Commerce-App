class Tag < ApplicationRecord
    # prevents blank fields, duplicate tags
    validates :name, presence: true, uniqueness: {case_sensitive: false}

    has_many :product_tags, dependent: :destroy
    has_many :products, through: :product_tags
end
