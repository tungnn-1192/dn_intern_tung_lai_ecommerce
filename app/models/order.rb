class Order < ApplicationRecord
  enum status: {pending: 0, rejected: 1, cancled: 2,
                delivering: 3, delivered: 4}

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items, dependent: :destroy
end
