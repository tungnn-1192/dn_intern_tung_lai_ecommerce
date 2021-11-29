module Admin::OrdersHelper
  HIDDEN_ATTRIBUTES = {order: "user_id",
                       order_item: %w(id order_id product_id),
                       user: %w(password remember_digest password_digest)}
                      .freeze

  def render_order_header attribute
    if attribute == "user_id"
      User.human_attribute_name "email"
    else
      Order.human_attribute_name attribute
    end
  end

  def render_index_order order, name
    if name == "status"
      render_order_statuses order
    elsif name == "user_id"
      order.user_email
    elsif Order.attribute_include?(:datetime_attributes, name)
      translate_datetime_long order.send(name)
    elsif Order.attribute_include?(:currency_attributes, name)
      translate_price order.send(name)
    else
      order.send(name)
    end
  end

  def render_order_statuses order
    select_tag :status, options_for_select(Order.human_attribute_statuses,
                                           order.status_value),
               class: "form-select select-status"
  end

  def render_show_order order, name
    if name == "status"
      order.humanized_enum :status
    else
      render_index_order order, name
    end
  end

  def render_show_order_item order_item, name
    if OrderItem.attribute_include?(:datetime_attributes, name)
      translate_datetime_long order_item.send(name)
    elsif OrderItem.attribute_include?(:currency_attributes, name)
      translate_price order_item.send(name)
    else
      order_item.send(name)
    end
  end

  def render_show_user user, name
    if User.attribute_include?(:datetime_attributes, name)
      translate_datetime_long user.send(name)
    elsif %w(name role).include? name
      user.humanized_enum name
    else
      user.send(name)
    end
  end

  def shown_attributes model
    key = to_snakecase(model.to_s).to_sym
    rejects = HIDDEN_ATTRIBUTES[key]
    model.attribute_names.reject{|name| rejects.include? name}
  end

  def translate_datetime_long datetime
    l datetime, format: :long
  end
end
