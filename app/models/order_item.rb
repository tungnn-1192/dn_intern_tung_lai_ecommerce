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
  class << self
    def hidden_attributes
      %w(id order_id)
    end

    def shown_attributes
      attribute_names.reject{|name| hidden_attributes.include? name}
    end

    def datetime_attributes
      %w(created_at updated_at)
    end

    def currency_attributes
      %w(current_price)
    end
  end
end
