class Admin::BaseController < ActionController::Base
  layout "admin/layouts/base"
  include Admin::BaseHelper
  before_action :set_locale
end
