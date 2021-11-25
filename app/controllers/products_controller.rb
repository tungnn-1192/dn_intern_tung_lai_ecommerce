class ProductsController < ApplicationController
  before_action :prepare_category_ids, :filter_products, only: :index

  def index
    @products_found = @products.count
    @products = @products.page(params[:page])
  end

  private

  def filter_products
    @products = Product.search_by_name(filters_value(:name))
                       .search_by_category(@category_params)
                       .search_by_range(:rating, range_of(:rating))
                       .search_by_range(:price, range_of(:price))
                       .search_by_range(:inventory, range_of(:inventory))
  end

  def filters_value key
    params[:filters]&.fetch(key, nil)
  end

  def range_of name
    return if (value = filters_value(name)).nil?

    {min: value[:min].to_f,
     max: value[:max].to_f}
  end

  def prepare_category_ids
    return unless categories_params_valid?

    @category_params = merge_category_ids(params[:filters][:categories])
  end

  def categories_params_valid?
    params.dig(:filters, :categories, :parents) ||
      params.dig(:filters, :categories, :children)
  end

  def merge_category_ids categories
    ids = {}
    categories[:parents]&.each do |id|
      next if (category = Category.find_by id: id).nil?

      if category.children.empty?
        ids[id] = true
      else
        category.children.each{|child| ids[child.id] = true}
      end
    end
    categories[:children]&.each{|id| ids[id.to_i] = true}
    ids.keys
  end
end
