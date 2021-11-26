class Order < ApplicationRecord
  enum status: {pending: 0, rejected: 1, canceled: 2,
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
    def datetime_attributes
      %w(created_at updated_at)
    end

    def currency_attributes
      %w(total_price)
    end

    def human_attribute_statuses
      statuses.map{|k, v| [Order.humanize_enum(:status, k), v]}
    end
  end
end
