require "rails_helper"
require_relative "shared_helpers"

RSpec.describe SessionsController, type: :controller do
  let(:user){create(:user)}
  def password_login user, options = {}
    post :create, params: {user: {email: options.fetch(:email, user.email),
                                  password: options.fetch(:password, user.password)}},
    session: nil
  end

  describe "routing" do
    it{should route(:get, "/login").to(action: :new)}
    it{should route(:post, "/login").to(action: :create)}
    it{should route(:get, "/logout").to(action: :destroy)}
  end

  describe "GET #new" do
    it "renders the login view if user not logged in" do
      get :new
      expect(response).to render_template("new")
    end
    it "redirects to root url if user logged in" do
      sign_in user
      get :new
      expect(response).to redirect_to(root_url)
    end
  end

  describe "POST #create" do
    context "when login sucessfully" do
      before do
        password_login user
      end

      it{should set_session[:user_id].to(user.id)}
      it{should set_flash[:success].to(I18n.t("logged_in_as", name: user.first_name))}
      it{should redirect_to(root_url)}
    end

    context "when login failed" do
      context "when wrong email or password" do
        before do
          password_login user, password: user.password + "foobar"
        end

        it{should set_flash[:danger].to(I18n.t("email_password_invalid"))}
        it{should redirect_to(action: :new)}
      end

      context "when logging in as admin" do
        let(:admin){create(:user, role: :admin)}
        before do
          password_login admin
        end
        it{should set_flash[:warning].to(I18n.t("admins_not_allowed"))}
        it{should redirect_to(action: :new)}
      end
    end
  end

  describe "GET #destroy" do
    before do
      sign_in user
      get :destroy
    end

    it{should redirect_to(root_url)}

    context "when logged in" do
      it{should_not set_session[:user_id]}
      it{should set_flash[:success].to(I18n.t("logged_out"))}
    end
  end
end
