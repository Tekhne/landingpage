RSpec::Matchers.define :be_invalid_for do |attribute|
  match do |model|
    expect(model).not_to be_valid
    expect(model.errors).to have_key(attribute)
  end
end
