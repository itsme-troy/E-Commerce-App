class Product < ApplicationRecord
    #  include the Notifications module
    include Notifications

    # Associations
    belongs_to :category, optional: true # null = true for products
    belongs_to :creator, class_name: "User", foreign_key: "created_by_id", optional: true

    has_many :product_tags, dependent: :destroy
    has_many :tags, through: :product_tags

    # a product can have many subscribers (has_many)
    #  tells Rails how to join queries between the two database tables.
    has_many :subscribers, dependent: :destroy
    
    # Attachments
    has_one_attached :featured_image
    has_rich_text :description

    # validations 
    validates :name, presence: true
    #  validate that inventory count is never a negative number
    validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }

    # callbacks 
    # an Active Record callback that is fired after changes are saved to the database
    after_update_commit :notify_subscribers, if: :back_in_stock?

    # tells the callback to run only if the back_in_stock? method returns true.
    def back_in_stock?
      inventory_count_previously_was.zero? && inventory_count > 0
    end

    # uses the Active Record association to query the subscribers table
    # for all subscribers for this specific product and then queues
    # up the in_stock email to be sent to each of them.
    def notify_subscribers
      subscribers.each do |subscriber|
        ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_later
      end
    end
end
