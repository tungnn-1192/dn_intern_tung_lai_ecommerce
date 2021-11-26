module Admin::OrdersHelper
  def order_statuses
    Order.statuses
  end
end
