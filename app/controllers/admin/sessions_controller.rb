class Admin::SessionsController < Admin::BaseController
  layout "../admin/sessions/base", only: [:new]

  def new; end
end
