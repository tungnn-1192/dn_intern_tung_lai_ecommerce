class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def humanized_enum enum_name
    enum_name = enum_name.to_sym
    return unless respond_to? enum_name

    self.class.humanize_enum enum_name, send(enum_name)
  end

  class << self
    def humanize_enum enum_name, enum_value
      I18n.t("activerecord.attributes.#{model_name.i18n_key}"\
        ".#{enum_name.to_s.pluralize}.#{enum_value}")
    end

    def attribute_include? attribute, value
      attribute = attribute.to_sym
      return unless respond_to? attribute

      send(attribute).include? value
    end
  end
end
