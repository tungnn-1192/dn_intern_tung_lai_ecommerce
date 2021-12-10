class Admin::OrdersController < Admin::BaseController
  before_action :load_orders_paginate, only: :index
  before_action :load_order, only: %i(show update)

  def index; end

  def show; end

  def update
    previous_status = @order.status
    @order.status = Order.statuses.key(params[:status].to_i)
    if @order.save
      flash[:success] = t("admin.status_updated")
      OrderStatusMailer.status_changed(@order, previous_status).deliver_later
    else
      flash[:danger] = t("admin.status_update_failed")
    end
    redirect_to admin_orders_url
  end

  private

  def load_orders_paginate
    @orders = Order.order_by_status.order_by_last_updated
                   .page(params[:page])
                   .per(Settings.paginate.per_page)
  end

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:warning] = t("admin.order_not_found", id: params[:id])
    redirect_to admin_orders_url
  end
end
