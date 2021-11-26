class Order < ApplicationRecord
  enum status: {pending: 0, rejected: 1, cancled: 2,
                delivering: 3, delivered: 4}

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items, dependent: :destroy
  class << self
    def hidden_attributes
      %w(user_id)
    end

    def shown_attributes
      attribute_names.reject{|name| hidden_attributes.include? name}
    end

    def datetime_attributes
      %w(created_at updated_at)
    end

    def currency_attributes
      %w(total_price)
    end
  end
end
