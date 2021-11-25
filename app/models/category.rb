class Category < ApplicationRecord
  validates :title, presence: true,
                    length: {maximum: Settings.length.digit_255}

  has_many :children, class_name: Category.name, foreign_key: :parent_id,
            dependent: :destroy
  belongs_to :parent, class_name: Category.name, optional: true
  has_many :products, dependent: :destroy
  scope :parent_categories, ->{where parent_id: nil}
  scope :children_of, ->(id){where parent_id: id}
end
