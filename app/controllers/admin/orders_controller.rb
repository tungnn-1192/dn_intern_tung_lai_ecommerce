class Admin::OrdersController < Admin::BaseController
  before_action :load_orders_paginate, only: :index
  before_action :load_order, only: %i(show update)

  def index; end

  def show; end

  def update
    previous_status = @order.status
    if @order.update_attribute :status, Order.statuses.key(params[:status].to_i)
      flash[:success] = t("admin.status_updated")
      OrderStatusMailer.status_changed(@order, previous_status).deliver_later
    else
      flash[:danger] = t("admin.status_update_failed")
    end
    redirect_to admin_orders_url
  end

  private

  def load_orders_paginate
    @orders = Order.page params[:page]
  end

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order.present?

    flash[:warning] = t("admin.order_not_found", id: params[:id])
    redirect_to admin_orders_url
  end
end
