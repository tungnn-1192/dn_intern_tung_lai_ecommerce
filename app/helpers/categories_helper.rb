module CategoriesHelper
  def parent_categories
    Category.where parent_id: nil
  end

  def categories_carousel max = 10
    Category.limit(max)
  end
end
