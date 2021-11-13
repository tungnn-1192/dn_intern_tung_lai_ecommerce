module CategoriesHelper
  def parent_categories
    Category.where parent_id: nil
  end

  def categories_carousel max = 10
    Category.limit(max)
  end

  def featured_products max = 12
    Product.order(updated_at: :desc).limit(max)
  end

  def snake_join strings
    return "" if strings.empty?

    strings[0] = Strings::Case.snakecase(strings[0])
    strings.reduce{|a, e| a + " #{Strings::Case.snakecase(e)}"}
  end
end
