class ApplicationController < ActionController::Base
  include SessionsHelper
  include CategoriesHelper

  before_action :set_locale, :fake_cart, :add_index_breadcrumb
  protect_from_forgery with: :exception
  def default_url_options
    {locale: I18n.default_locale}
  end
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def add_index_breadcrumb
    add_breadcrumb "Home", root_url
  end
end
