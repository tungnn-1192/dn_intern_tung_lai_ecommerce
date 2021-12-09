require "rails_helper"
require_relative "../shared_helpers"

RSpec.describe Admin::SessionsController, type: :controller do
  let(:admin){create(:user, role: :admin)}

  def password_login user, options = {}
    post :create, params: {login: {email: options.fetch(:email, user.email),
                                   password: options.fetch(:password, user.password)}}
  end

  describe "routing" do
    it{should route(:get, "/admin/login").to(action: :new)}
    it{should route(:post, "/admin/login").to(action: :create)}
    it{should route(:get, "/admin/logout").to(action: :destroy)}
  end

  describe "GET #new" do
    context "when user not logged in" do
      it "renders the login view" do
        get :new
        expect(response).to render_template("new")
      end
    end
    context "when user logged in" do
      it "redirects to admin root url" do
        sign_in admin
        get :new
        expect(response).to redirect_to(admin_root_url)
      end
    end
  end

  describe "POST #create" do
    context "when login sucessfully" do
      before{password_login admin}

      it{should set_session[:admin_id].to(admin.id)}
      it{should set_flash[:success].to(I18n.t("admin.logged_in_as", name: admin.first_name))}
      it{should redirect_to(admin_root_url)}
    end

    context "when login failed" do
      context "when wrong email or password" do
        before{password_login admin, password: admin.password + "foobar"}

        it{should set_flash[:danger].to(I18n.t("admin.log_in_failed"))}
        it{should redirect_to(action: :new)}
      end

      context "when logging in as admin" do
        let(:user){create(:user)}
        before{password_login user}

        it{should set_flash[:warning].to(I18n.t("admin.users_not_allowed"))}
        it{should redirect_to(action: :new)}
      end
    end
  end

  describe "GET #destroy" do
    before do
      sign_in admin
      get :destroy
    end

    it{should redirect_to(admin_login_url)}

    context "when logged in" do
      it{should_not set_session[:admin_id]}
    end
  end
end
