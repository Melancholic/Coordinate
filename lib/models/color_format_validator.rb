class ColorFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless Color.all.include?(value.upcase)
      object.errors[attribute] << (options[:message] || "is not a proper color.") 
    end
  end
end