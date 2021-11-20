module SessionsHelper
  # fake the cart only once since the session start, only for now
  def fake_cart
    return if session[:cart] == {} || session[:cart].present?

    session[:cart] = {}
    session[:cart][1.to_s] = 1
    session[:cart][2.to_s] = 2
    session[:cart][3.to_s] = 4
    session[:cart][4.to_s] = 3
  end

  def cart_count
    return 0 if session[:cart].blank?

    cnt = 0
    session[:cart].each do |pair|
      # pair[0] = id
      cnt += Product.exists?(id: pair[0]) ? 1 : 0
    end

    cnt
  end

  def cart_contents
    return if session[:cart].blank?

    products_contents = {}
    session[:cart].each do |pair|
      retrieved_item = Product.select(:id, :name, :price, :inventory)
                              .find_by(id: pair[0])
      products_contents[pair] = retrieved_item if retrieved_item
    end

    products_contents
  end

  def subtotal
    return 0 if session[:cart].blank?

    subtotal = 0
    session[:cart].each do |pair|
      # pair[0] = id, pair[1] = qty
      retrieved_price = Product.where(id: pair[0]).pluck(:price)
      subtotal += retrieved_price.any? ? retrieved_price[0].to_f * pair[1] : 0
    end

    subtotal.round(2)
  end
end
