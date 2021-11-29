module OrdersHelper
  def build_order_item item
    order_item = {}
    order_item[:product_id] = item[0][0]
    order_item[:quantity] = item[0][1]

    order_item
  end
end
