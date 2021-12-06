require "rails_helper"

RSpec.shared_examples "validates non-negative integer" do |attribute_name|
  describe "only integer" do
    it{should validate_numericality_of(attribute_name).only_integer}
    it "should have correct error message" do
      invalids = %w(1.5 -1.5)
      invalids.each do |non_integer_value|
        subject.send("#{attribute_name}=", non_integer_value)
        subject.valid?
        error_message = subject.errors[attribute_name][0]
        expect(error_message).to eq(I18n.t("errors.messages.not_an_integer"))
      end
    end
  end
  describe "greater than or equal to 0" do
    it do
      should validate_numericality_of(attribute_name)
        .is_greater_than_or_equal_to(0)
    end
    it "should have correct error message" do
      subject.send("#{attribute_name}=", -1)
      subject.valid?
      error_message = subject.errors[attribute_name][0]
      expect(error_message)
        .to eq(I18n.t("errors.messages.greater_than_or_equal_to", count: 0))
    end
  end
end

RSpec.describe Product, type: :model do
  subject{create :product}
  describe "validations" do
    it "is valid when pass validations" do
      expect(subject).to be_valid
    end

    context "name" do
      it do
        should validate_presence_of(:name)
          .with_message(I18n.t("errors.messages.required"))
      end
      it do
        should validate_length_of(:name)
          .is_at_most(Settings.length.digit_255)
          .with_message(I18n.t("errors.messages.too_long",
                               count: Settings.length.digit_255))
      end
    end

    context "price" do
      it do
        should validate_presence_of(:price)
          .with_message(I18n.t("errors.messages.required"))
      end
      it_behaves_like "validates non-negative integer", :price
    end

    context "inventory" do
      it do
        should validate_presence_of(:inventory)
          .with_message(I18n.t("errors.messages.required"))
      end
      it_behaves_like "validates non-negative integer", :inventory
    end

    context "unit" do
      it do
        should validate_presence_of(:unit)
          .with_message(I18n.t("errors.messages.required"))
      end
      it do
        should validate_length_of(:unit)
          .is_at_most(Settings.length.digit_50)
          .with_message(I18n.t("errors.messages.too_long",
                               count: Settings.length.digit_50))
      end
    end
    context "category" do
      it do
        should validate_presence_of(:category)
          .with_message(I18n.t("errors.messages.required"))
      end
    end
  end

  describe "associations" do
    it{should belong_to(:category)}
  end

  describe "scopes" do
    let!(:products){create_list(:product, 5)}
    context "search_by_range" do
      let(:product){create(:product, price: 200_000)}
      it "includes products with ranged price" do
        range = {min: 0, max: 200_000}
        expect(Product.search_by_range("price", range)).to include(product)
      end
      it "exclues products with out-ranged price" do
        range = {min: 300_000, max: 1_000_000}
        expect(Product.search_by_range("price", range)).not_to include(product)
      end
      it "returns previous Relation if range not present" do
        expect(Product.search_by_range("price", nil)).to include(product)
      end
    end
    context "search_by_name" do
      let(:product){create(:product, name: "Not Really a product")}
      it "includes products with name contains whole keyword" do
        keyword = "Really"
        expect(Product.search_by_name(keyword)).to include(product)
      end
      it "searches case-insensitively" do
        keyword = "reAlLy"
        expect(Product.search_by_name(keyword)).to include(product)
      end
      it "exclues products with name does not contain whole keyword" do
        keyword = "Possibly"
        expect(Product.search_by_name(keyword)).not_to include(product)
      end
      it "returns previous Relation if range not present" do
        expect(Product.search_by_name(nil)).to include(product)
      end
    end
    context "search_by_category" do
      it "includes products being in category IDs" do
        ids = [subject.category.id]
        expect(Product.search_by_category(ids)).to include(subject)
      end
      it "exclues products not being in category IDs" do
        ids = [-1]
        expect(Product.search_by_category(ids)).not_to include(subject)
      end
      it "returns previous Relation if range not present" do
        expect(Product.search_by_category(nil)).to include(subject)
      end
    end
  end

  describe "delegates" do
    it{should delegate_method(:title).to(:category).with_prefix(:category)}
  end

  context "methods" do
    let(:product) do
      create(:product, :with_parent_category,
             parent_cat: subject.category)
    end
    describe "#parent_category" do
      it "should returns parent category" do
        expect(product.parent_category).to eq(product.category.parent)
      end
    end
    describe "#has_parent_category?" do
      it "returns true when has parent category" do
        product.category
        expect(product.has_parent_category?).to be true
      end
      it "returns false when does not have parent category" do
        expect(subject.has_parent_category?).to be false
      end
    end
  end
end
