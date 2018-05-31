require 'rails_helper'

RSpec.describe LogsAndRaisesExceptions do
  describe '#log_and_raise' do
    class Fake
      include LogsAndRaisesExceptions

      class Error < StandardError
        attr_accessor :original_exception
      end

      def test(exception, message, options = {})
        raise exception
      rescue StandardError => ex
        log_and_raise(ex, message, options)
      end
    end

    class FakeException < StandardError
      attr_accessor :original_exception
    end

    let(:message) { 'There were problems.' }

    let(:model_exception) do
      ActiveRecord::RecordInvalid.new(invalid_contact)
    end

    let(:invalid_contact) do
      build(:contact).tap { |c| c.errors.add(:email) }
    end

    subject(:fake) { Fake.new }

    before do
      allow(Rails.logger).to receive(:error)
    end

    it 'logs exception', focus: true do
      begin
        fake.test(model_exception, message)
      rescue StandardError
        # noop
      end
      expect(Rails.logger).to have_received(:error)
    end

    describe 'when exception is an ActiveRecord::RecordInvalid' do
      it 'logs model errors' do
        begin
          fake.test(model_exception, message)
        rescue StandardError
          # noop
        end
        expect(Rails.logger).to have_received(:error).with(/errors hash/i)
      end
    end

    describe 'when an exception class is given via options[:klass]' do
      it 'raises given exception' do
        expect do
          fake.test(model_exception, message, klass: FakeException)
        end.to raise_exception(FakeException)
      end

      describe 'when given exception responds to :original_exception=' do
        it 'raises given exception with original_exception attribute set' do
          expect do
            fake.test(model_exception, message, klass: FakeException)
          end.to raise_exception do |exception|
            expect(exception.original_exception).to eq(model_exception)
          end
        end
      end
    end

    describe 'when inner Error exception class is defined' do
      it 'raises inner Error' do
        expect { fake.test(model_exception, message) }.to \
          raise_exception(Fake::Error)
      end

      describe 'when inner Error responds to :original_exception=' do
        it 'raises inner Error with original_exception attribute set' do
          expect { fake.test(model_exception, message) }.to \
            raise_exception do |exception|
              expect(exception.original_exception).to eq(model_exception)
            end
        end
      end
    end
  end
end
