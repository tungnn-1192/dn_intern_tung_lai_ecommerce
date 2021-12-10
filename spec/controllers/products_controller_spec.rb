require "rails_helper"
require "byebug"

def send_index_request params
  get :index, params: params, session: nil
end

def send_show_request product_id
  get :show, params: {id: product_id}
end

def expect_product_found should_found, expected
  expect(assigns(:products))
    .to should_found ? eq(expected) : be_empty
end

def expect_filtered criteria, should_found, options = {}
  params = options.fetch(:params, filters: criteria || {})
  send_index_request params
  expect_product_found should_found, options.fetch(:expected, [product])
end

RSpec.shared_examples "when a filter criteria is missing" do |filter_key|
  let(:full_params) do
    {filters: {
      name: "def",
      categories: {children: [product.category.id]},
      rating: {min: 0, max: product.rating},
      price: {min: 0, max: product.price},
      inventory: {min: 0, max: product.inventory}
    }}
  end
  let(:params) do
    x = full_params.dup
    x[:filters].delete(filter_key) if filter_key.present?
    x
  end
  after{expect_filtered nil, @should_found, params: @params}

  context "when #{filter_key || 'nothing'} is missing" do
    it "should return products that meet all other criterias" do
      @params = params
      @should_found = true
    end
    it "should not return products that fail one of the other criterias" do
      @params = params
      if @params[:filters][:name]
        @params[:filters][:name] = "xyz"
      else
        @params[:filters][:price] = {min: 0, max: product.price - 1}
      end
      @should_found = false
    end
  end
end

RSpec.shared_context "products hierachy" do
  before do
    @product = create(:product, :with_parent_category, parent_cat: create(:category))
    @sibling_product = create(:product, category: @product.category)
    @nephew_product = create(:product, :with_parent_category, parent_cat: @product.parent_category)
  end
end

RSpec.describe ProductsController, type: :controller do
  let(:product){create(:product, name: "abc def ghi")}

  describe "routing" do
    it{should route(:get, "/products").to(action: :index)}
    it{should route(:get, "/products/1").to(action: :show, id: 1)}
  end

  describe "GET #index" do
    it "should return all products when not filtering" do
      expect_filtered nil, true, params: nil
    end

    context "when filtering" do
      context "when filter by name" do
        it "should return no products when no products contain the name parameter" do
          criteria = {name: "xyz"}
          expect_filtered criteria, false
        end

        it "should return products containing the name parameter" do
          criteria = {name: "def"}
          expect_filtered criteria, true
        end

        context "when no name parameter specified" do
          it_behaves_like "when a filter criteria is missing", :name
        end
      end

      context "when filter by price" do
        it "should return all products with price in that range" do
          criteria = {price: {min: 0, max: product.price}}
          expect_filtered criteria, should_found: true
        end

        context "when no price parameter specified" do
          it_behaves_like "when a filter criteria is missing", :price
        end

        context "when result is empty" do
          after(:each) do
            expect_filtered @criteria, false
          end

          it "should have min = max = 0" do
            @criteria = {price: {min: 0, max: 0}}
          end
          it "should have min and max less than 0" do
            @criteria = {price: {min: -1, max: -1}}
          end
          it "should have no products with price in that range" do
            @criteria = {price: {min: 0, max: product.price - 1}}
          end
        end
      end

      context "when filter by rating" do
        it "should return all products with rating in that range" do
          criteria = {rating: {min: 0, max: product.rating}}
          expect_filtered criteria, true
        end

        context "when no rating parameter specified" do
          it_behaves_like "when a filter criteria is missing", :rating
        end

        context "when result is empty" do
          after(:each) do
            expect_filtered @criteria, false
          end

          it "should have min and max being negative" do
            @criteria = {rating: {min: -1, max: -1}}
          end
          it "should have min and max greater than 5" do
            @criteria = {rating: {min: 6, max: 6}}
          end
          it "should have no products in that range" do
            @criteria = {rating: {min: 0, max: product.rating - 1}}
          end
        end
      end

      context "when filter by inventory" do
        it "should return all products with inventory in that range" do
          criteria = {inventory: {min: 0, max: product.inventory}}
          expect_filtered criteria, true
        end

        context "when no inventory parameter specified" do
          it_behaves_like "when a filter criteria is missing", :inventory
        end

        context "when result is empty" do
          after(:each) do
            expect_filtered @criteria, false
          end

          it "should have min = max = 0" do
            @criteria = {inventory: {min: 0, max: 0}}
          end
          it "should have min and max less than 0" do
            @criteria = {inventory: {min: -1, max: -1}}
          end
          it "should have no products with inventory in that range" do
            @criteria = {inventory: {min: 0, max: product.inventory - 1}}
          end
        end
      end

      context "when filter by category" do
        include_context "products hierachy"
        after{expect_filtered @criteria, true, expected: @expected}

        context "when only parent parameter is specified" do
          it "should return products with such parent category IDs" do
            @criteria = {categories: {parents: [@product.parent_category.id]}}
            @expected = [@product, @sibling_product, @nephew_product]
          end
        end

        context "when only children parameter is specified" do
          it "should return products with such category IDs" do
            @criteria = {categories: {children: [@product.category.id]}}
            @expected = [@product, @sibling_product]
          end
        end

        context "when both parent and children parameters is specified" do
          it "should return products with parent category IDs in parents param and products with category IDs in children params" do
            @criteria = {categories: {parents: [@product.parent_category.id],
                                      children: [@product.category.id]}}
            @expected = [@product, @sibling_product, @nephew_product]
          end
        end
      end

      context "when filter by all criterias" do
        it_behaves_like "when a filter criteria is missing", nil
      end
    end
  end

  describe "GET #show" do
    context "when product ID does not existed" do
      before{send_show_request(product.id + 1)}

      it{should set_flash[:warning].to(I18n.t("product_not_found"))}
      it{should redirect_to(products_url)}
    end

    context "when product ID exists" do
      include_context "products hierachy"
      before{send_show_request(@product.id)}

      it "should assigns the related products" do
        expect(assigns(:related_products)).to eq([@product, @sibling_product, @nephew_product])
      end
      it "should assigns the product details" do
        expect(assigns(:product)).to eq(@product)
      end
      it{should render_template("show")}
    end
  end
end
