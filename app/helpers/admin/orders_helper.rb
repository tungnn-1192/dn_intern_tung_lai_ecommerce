module Admin::OrdersHelper
  def render_order_header attribute
    if attribute == "user_id"
      User.human_attribute_name "email"
    else
      Order.human_attribute_name attribute
    end
  end

  def render_order_attribute order, name
    if name == "status"
      render_order_statuses order
    elsif name == "user_id"
      order.user_email
    elsif Order.datetime_attributes.include?(name)
      l order.send(name), format: :long
    elsif Order.currency_attributes.include?(name)
      translate_price order.send(name)
    else
      order.send(name)
    end
  end

  def render_order_statuses order
    select_tag :status, options_for_select(Order.statuses, order.status_value),
               class: "form-select select-status"
  end
end
