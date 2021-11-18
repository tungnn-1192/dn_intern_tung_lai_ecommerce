module CategoriesHelper
  def parent_categories
    Category.parent_categories
  end

  def featured_products max = Settings.length.featured_products.max
    Product.featured_products max
  end

  def to_filters_hash products
    products.each_with_object({}) do |e, h|
      cat = e.category
      # h[cat.id] = cat.title
      h[cat.parent.id] = cat.parent.title if cat.parent.present?
    end
  end

  def snake_join strings
    return "" if strings.empty?

    strings.reduce(""){|a, e| a + " #{to_snakecase e}"}
  end

  def to_snakecase string
    Strings::Case.snakecase string
  end
end
