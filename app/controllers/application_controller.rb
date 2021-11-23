class ApplicationController < ActionController::Base
  include ApplicationHelper
  include CategoriesHelper
  include CartsHelper

  before_action :set_locale, :fake_cart
  protect_from_forgery with: :exception
end
