require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#field_error' do
    let(:attribute) { :email }

    let(:model) do
      Contact.new.tap { |c| c.errors.add(attribute, :invalid) }
    end

    describe 'when given model has no errors' do
      it 'returns nil' do
        model.errors.clear
        expect(helper.field_error(model, attribute)).to be_nil
      end
    end

    it 'returns field error content' do
      expect(helper.field_error(model, attribute)).to \
        match(/class="field-error"/)
    end

    describe 'when an optional prefix is given' do
      it 'returns field error containing prefix' do
        expect(helper.field_error(model, attribute, prefix: 'Test')).to \
          match(/>Test/)
      end
    end

    describe 'when an optional class string is given' do
      it 'returns field error containing class' do
        expect(helper.field_error(model, attribute, class: 'test-class')).to \
          match(/test-class/)
      end
    end
  end
end
