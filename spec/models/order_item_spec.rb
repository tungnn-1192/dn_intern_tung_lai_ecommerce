require "rails_helper"

RSpec.describe OrderItem, type: :model do
  subject{create :order_item}
  describe "when do validations" do
    it "should be valid if pass validations" do
      expect(subject).to be_valid
    end
    describe "when validate quantity" do
      it "should be presence or show correct error message" do
        should validate_presence_of(:quantity)
          .with_message(I18n.t("errors.messages.required"))
      end
      it "should be a number and other than 0" do
        should validate_numericality_of(:quantity)
          .is_other_than(Settings.digit.zero)
      end
      context "when fail validation" do
        it "should show correct error message when not a number" do
          subject.quantity = "aaa"
          subject.valid?
          error_message = subject.errors[:quantity][0]
          expect(error_message).to eq(I18n.t("errors.messages.not_a_number"))
        end
        it "should show correct error message when is 0" do
          subject.quantity = 0
          subject.valid?
          error_message = subject.errors[:quantity][0]
          expect(error_message).to eq(I18n.t("errors.messages.other_than",
                                             count: 0))
        end
      end
    end
  end
  describe "when validate associations" do
    it{should belong_to(:order)}
    it{should belong_to(:product)}
  end
  describe "when validate callbacks" do
    it "should set current price at before save" do
      product = create(:product)
      subject.product = product
      subject.save
      expect(subject.current_price).to eq(product.price)
    end
    it "should update product inventory at after save" do
      product = create(:product, inventory: subject.quantity + 1)
      subject.product = product
      subject.save
      expect(product.inventory).to eq(1)
    end
  end
end
