class Admin::OrdersController < Admin::BaseController
  before_action :load_orders_paginate, only: :index

  def index; end

  private

  def load_orders_paginate
    @orders = Order.page params[:page]
  end
end
