class Admin::OrdersController < Admin::BaseController
  before_action :load_orders_paginate, only: :index
  before_action :load_order, only: %i(show update)

  def index; end

  def show; end

  def update
    previous_status = @order.status
    if @order.update_attribute :status, Order.statuses.key(params[:status].to_i)
      flash[:success] = "Updated status"
      OrderStatusMailer.status_changed(@order, previous_status).deliver_later
    else
      flash[:danger] = "Update status failed"
    end
    redirect_to admin_orders_url
  end

  private

  def load_orders_paginate
    @orders = Order.page params[:page]
  end

  def load_order
    @order = Order.find_by id: params[:id]
    redirect_to admin_orders_url if @order.nil?
  end
end
