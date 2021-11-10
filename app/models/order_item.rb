class OrderItem < ApplicationRecord
  after_create :set_order_total_price
  before_save :set_current_price
  validates :quantity, presence: true

  belongs_to :order
  belongs_to :product

  private
  def set_order_total_price
    order.total_price += current_price * quantity
    order.save
  end

  def set_current_price
    self.current_price = product.price
  end
end
