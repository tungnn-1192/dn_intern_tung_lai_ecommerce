class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w\-.+]+@[a-z\-\d.]+\.[a-z]+\z/i.freeze
  VALID_TELEPHONE_REGEX = /\A0[\d ]+\z/i.freeze
  before_save{email.downcase!}
  validates :email, :first_name, :last_name, :password_confirmation,
            presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false},
                    length: {maximum: Settings.length.digit_255},
                    allow_blank: true
  validates :first_name, length: {maximum: Settings.length.digit_50}
  validates :last_name, length: {maximum: Settings.length.digit_50}
  validates :password,  length: {minimum: Settings.length.digit_8,
                                 maximum: Settings.length.digit_16},
                        confirmation: true,
                        allow_blank: true
  validates :telephone, format: {with: VALID_TELEPHONE_REGEX},
                        length: {minimum: Settings.length.digit_9,
                                 maximum: Settings.length.digit_12},
                        allow_blank: true
  validates :address, length: {maximum: Settings.length.digit_255}
  has_secure_password

  enum role: {user: 0, admin: 1}
  enum gender: {female: false, male: true}
  has_many :orders, dependent: :destroy
  class << self
    def hidden_attributes
      %w(password_digest remember_digest)
    end

    def shown_attributes
      attribute_names.reject{|name| hidden_attributes.include? name}
    end

    def datetime_attributes
      %w(birthday created_at updated_at)
    end
  end
end
