require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validates" do
    it{should validate_presence_of(:title)}
    it{should validate_length_of(:title).is_at_most(Settings.length.digit_255)}
  end
  describe "relations" do
    describe "has_many" do
      it do
        should have_many(:children).class_name(:Category)
                                   .with_foreign_key(:parent_id)
                                   .dependent(:destroy)
      end
    end
    context "belongs_to" do
      it do
        should belong_to(:parent).class_name(:Category).optional
      end
    end
  end
  describe "scope" do
    context "parent_categories" do
      before(:all){create_list :category, 3}
      it "returns categories with parent_id of nil" do
        expect(Category.parent_categories.limit(3).map(&:parent_id)).to eq([nil, nil, nil])
      end
    end
  end
end
