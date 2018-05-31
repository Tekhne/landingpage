require 'rails_helper'

RSpec.describe Subscriptions do
  describe '#subscribe' do
    let(:params) { ActionController::Parameters.new(email: 'user@example.com') }

    subject(:subscriptions) { Subscriptions.new }

    before do
      allow(Contact).to receive(:create!)
      allow(subscriptions).to receive(:log_and_raise)
    end

    it 'creates a new contact from given params' do
      subscriptions.subscribe(params)
      expect(Contact).to have_received(:create!).with(email: params[:email])
    end

    describe 'when new contact is invalid' do
      it 'logs and raises exception' do
        contact = build(:contact)
        exception = ActiveRecord::RecordInvalid.new(contact)
        allow(Contact).to receive(:create!) { raise exception }
        subscriptions.subscribe(params)
        expect(subscriptions).to \
          have_received(:log_and_raise).with(exception, instance_of(String))
      end
    end

    describe 'when given params is missing email' do
      it 'logs and raises exception' do
        exception = ActionController::ParameterMissing.new(:email)
        allow(params).to receive(:fetch) { raise exception }
        subscriptions.subscribe(params)
        expect(subscriptions).to \
          have_received(:log_and_raise).with(exception, instance_of(String))
      end
    end
  end
end
