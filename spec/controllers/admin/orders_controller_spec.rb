require "rails_helper"
require_relative "../shared_helpers"

RSpec.describe Admin::OrdersController, type: :controller do
  let(:order){create(:order)}
  let(:admin){create(:user, role: :admin)}

  def load_order order_id, options = {}
    get :show, params: options.fetch(:params, id: order_id),
     session: options.fetch(:signed_in, false) ? {admin_id: admin.id} : nil
  end

  def update_status order_id, status, should_sign_in: true
    sign_in(admin) if should_sign_in
    put :update, params: {id: order_id, status: status}
  end

  describe "routing" do
    it{should route(:get, "/admin/orders").to(action: :index)}
    it{should route(:get, "/admin/orders/1").to(action: :show, id: 1)}
    it{should route(:put, "/admin/orders/1").to(action: :update, id: 1)}
  end

  describe "GET #index" do
    before{order}

    it "should redirect to login page if not signed in as admin" do
      get :index
      expect(response).to redirect_to(admin_login_url)
    end

    context "when signed in as admin" do
      before do
        sign_in admin
        get :index
      end

      it "should assign orders" do
        expect(assigns(:orders)).to eq([order])
      end
      it{should render_template("index")}
    end
  end
  describe "GET #show" do
    it "should redirect to login page when not signed in as admin" do
      load_order order.id
      expect(response).to redirect_to(admin_login_url)
    end
    it "should redirect to orders page when order id is invalid" do
      load_order -1, signed_in: true
      expect(response).to redirect_to(admin_orders_url)
    end

    context "when signed in and order id is valid" do
      before{load_order order.id, signed_in: true}

      it "should assign order detail" do
        expect(assigns(:order)).to eq(order)
      end
      it{should render_template("show")}
    end
  end

  describe "PUT #update" do
    it "should redirect to login page when not signed in as admin" do
      update_status order.id, nil, should_sign_in: false
      expect(response).to redirect_to(admin_login_url)
    end
    it "should redirect to orders page when order id is invalid" do
      update_status -1, nil
      expect(response).to redirect_to(admin_orders_url)
    end

    context "when status is not recognized" do
      before{update_status order.id, -1}

      it{should set_flash[:danger].to(I18n.t("admin.status_update_failed"))}
      it{should redirect_to(admin_orders_url)}
    end

    context "when status is valid" do
      it "should show flash success and redirect to admin order page" do
        update_status order.id, 1
        expect(flash[:success]).to match I18n.t("admin.status_updated")
        expect(response).to redirect_to(admin_orders_path)
      end
    end
  end
end
