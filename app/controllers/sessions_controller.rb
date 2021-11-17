class SessionsController < ApplicationController
  include SessionsHelper
  def cart_index
    add_breadcrumb "Cart", cart_url
    fake_cart
    cart_contents
  end

  def cart_add
    cart_add_item
    redirect_to cart_url
  end

  def new
    redirect_to root_url unless session[:email].nil?
  end

  def create
    get_user_or_redirect
    if @user.authenticate(params[:user][:password])
      remember_user
      flash[:success] = "Logged in as #{@user.first_name}"
    else
      flash[:danger] = "Username or password invalid"
    end
    redirect_to root_url
  end
  private
  def get_user_or_redirect
    @user = User.find_by email: params[:user][:email]
    redirect_to root_url if @user.nil?
  end

  def remember_user
    session[:email] = @user.email
  end
end
