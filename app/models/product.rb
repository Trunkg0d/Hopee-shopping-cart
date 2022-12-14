class Product < ApplicationRecord
    acts_as_paranoid
    belongs_to :shop

    has_many :product_categories
    has_many :product_sizes
    has_many :product_colors

    has_many :categories, through: :product_categories
    has_many :sizes, through: :product_sizes
    has_many :colors, through: :product_colors

    has_one :cart_item, dependent: :destroy
    has_one :order_item
    default_scope -> {order(created_at: :desc)}
    mount_uploaders :images, ImageUploader
    serialize :images

    validates :name, presence: true
    validates :color_ids, presence: true
    validates :size_ids, presence: true
    validates :price, presence: true

end
