class OrderStatusMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_status_mailer.status_changed.subject
  #
  helper :order_status

  def status_changed order, previous_status
    @order = order
    @previous_status = previous_status
    @greeting = "Hi"

    mail to: order.user.email
  end
end
