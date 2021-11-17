class Product < ApplicationRecord
  validates :name, :price, :inventory, :unit, presence: true
  validates :name, length: {maximum: Settings.length.digit_255}
  validates :price, numericality: {only_integer: true,
                                   greater_than_or_equal_to: 0},
                    allow_blank: true
  validates :inventory, numericality: {only_integer: true,
                                       greater_than_or_equal_to: 0},
                        allow_blank: true
  validates :unit, length: {maximum: Settings.length.digit_50}

  belongs_to :category
  scope :featured_products,
        (lambda do |max|
          order(rating: :desc).limit(max)
        end)
  scope :pluck_attr,
        (lambda do |id, attr|
          where(id: id).pluck(attr)
        end)
  scope :basic_product_info,
        (lambda do |id|
          select(:id, :name, :price, :inventory).find_by(id: id)
        end)
end
