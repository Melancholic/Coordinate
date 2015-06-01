class LocaleFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless LANGUAGES.map{|x| x.second}.include?(value.downcase)
      object.errors[attribute] << (options[:message] || "is not a proper locale.") 
    end
  end
end