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
end
