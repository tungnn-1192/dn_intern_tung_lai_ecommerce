class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  def default_url_options
    {locale: I18n.default_locale}
  end
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
