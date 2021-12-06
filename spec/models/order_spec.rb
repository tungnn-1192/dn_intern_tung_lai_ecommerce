require "rails_helper"
require_relative "shared_examples"

RSpec.describe Order, type: :model do
  subject{create(:order)}
  describe "validations" do
    it "is validates when pass validations" do
      expect(subject).to be_valid
    end
    it do
      should validate_presence_of(:user)
        .with_message(I18n.t("errors.messages.required"))
    end
  end
  describe "associations" do
    it{should belong_to(:user)}
    it{should have_many(:order_items).dependent(:destroy)}
    it{should have_many(:products).dependent(:destroy).through(:order_items)}
  end
  describe "scope" do
    describe "order_by_status" do
      let!(:orders){Order.statuses.each{|status, _value| create(:order, status: status)}}
      it "sorts by status ascending" do
        Order.order_by_status.each_cons(2) do |left, right|
          expect(left.status <= right.status)
        end
      end
      it "sorts by last updated" do
        order = create(:order)
        expect(Order.order_by_last_updated.first).to eq(order)
      end
    end
  end
  describe "enum" do
    describe "status" do
      it do
        should define_enum_for(:status)
          .with_values(pending: 0, rejected: 1, canceled: 2,
                            delivering: 3, delivered: 4)
          .backed_by_column_of_type(:integer)
      end
    end
  end
  describe "delegate" do
    it{should delegate_method(:email).to(:user).with_prefix(:user)}
  end
  it{should accept_nested_attributes_for(:order_items)}
  describe "methods" do
    describe ".datetime_attributes" do
      it_behaves_like ".datetime_attributes"
    end
    describe ".currency_attributes" do
      it_behaves_like ".currency_attributes"
    end
  end
end
