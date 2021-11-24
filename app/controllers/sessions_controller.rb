class SessionsController < ApplicationController
  before_action :use_layout_auth, only: [:new]

  def new
    redirect_to root_url if current_user.present?
  end

  def create
    @current_user = User.find_by email: params[:user][:email], role: :user
    if @current_user&.authenticate(params[:user][:password])
      remember_user
      flash[:success] = t("logged_in_as", name: @current_user.first_name)
      redirect_to root_url
    else
      flash[:danger] = t("email_password_invalid")
      use_layout_auth
      render :new
    end
  end

  def destroy
    if current_user.present?
      session.delete :user_id
      @current_user = nil
      flash[:success] = t("logged_out")
    end
    redirect_to root_url
  end

  private

  def remember_user
    session[:user_id] = @current_user.id
  end

  def use_layout_auth
    @use_layout_auth = true
  end
end
