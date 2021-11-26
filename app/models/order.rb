class Order < ApplicationRecord
  enum status: {pending: 0, rejected: 1, cancled: 2,
                delivering: 3, delivered: 4}

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items, dependent: :destroy
  scope :order_by_status, ->{order :status}
  scope :order_by_last_updated, ->{order updated_at: :desc}
  delegate :email, to: :user, prefix: :user
  accepts_nested_attributes_for :order_items

  def status_value
    Order.statuses[status]
  end

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
