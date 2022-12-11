class Shop < ApplicationRecord
    belongs_to :user
    has_many :products, dependent: :destroy
    validates :name, presence: true
    validates :description, presence: true
    has_many :vouchers
end

