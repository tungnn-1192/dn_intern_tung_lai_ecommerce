class Admin::OrdersController < Admin::BaseController
  before_action :load_orders_paginate, only: :index

  def index; end

  private

  def load_orders_paginate
    @orders = Order.order_by_status.order_by_last_updated
                   .page(params[:page])
                   .per(Settings.paginate.per_page)
  end
end
