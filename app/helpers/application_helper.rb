module ApplicationHelper
  def build_title(string = nil)
    [string, 'Take Control of Your Career!'].compact.join(' - ')
  end

  def field_error(model, attribute, options = {})
    return unless model.errors.include?(attribute)
    error = model.errors[attribute].first
    options[:prefix] ||= 'Field'
    tag.div(
      "#{options[:prefix]} #{error}.",
      class: ['field-error', options[:class]].compact.join(' ')
    )
  end
end
