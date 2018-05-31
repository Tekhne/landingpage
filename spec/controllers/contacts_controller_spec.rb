require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe 'POST #create' do
    let(:create_params) do
      ActionController::Parameters.new(params).require(:contact).permit(:email)
    end

    let(:params) { { 'contact' => { 'email' => 'user@example.com' } } }
    let(:subscriptions) { instance_double('Subscriptions') }

    before do
      allow(Subscriptions).to receive(:new) { subscriptions }
      allow(subscriptions).to receive(:subscribe)
    end

    it 'subscribes user' do
      post :create, params: params
      expect(subscriptions).to have_received(:subscribe).with(create_params)
    end

    describe 'when subscribing user succeeds' do
      it 'redirects to contact_path' do
        post :create, params: params
        expect(response).to redirect_to(contact_path)
      end

      it 'sets flash["contacts_create_success"] to true' do
        post :create, params: params
        expect(flash['contacts_create_success']).to eq(true)
      end

      it 'redirects with HTTP status :see_other' do
        post :create, params: params
        expect(response).to have_http_status(:see_other)
      end
    end

    describe 'when subscribing user fails' do
      let(:exception) do
        Subscriptions::Error.new('subscriptions exception').tap do |s|
          s.original_exception = model_exception
        end
      end

      let(:model) { Contact.new.tap { |c| c.errors.add(:email) } }
      let(:model_exception) { ActiveRecord::RecordInvalid.new(model) }

      before do
        allow(subscriptions).to receive(:subscribe) { raise exception }
      end

      it 'sets flash.now.alert' do
        post :create, params: params
        expect(flash.now['alert']).to eq(exception.message)
      end

      describe 'when the cause of failure is a model exception' do
        it 'assigns @contact to invalid model' do
          post :create, params: params
          expect(assigns(:contact)).to eq(model)
        end
      end

      describe 'when the cause of failure is not a model exception' do
        let(:exception) do
          Subscriptions::Error.new('subscriptions exception').tap do |s|
            s.original_exception = StandardError.new('original exception')
          end
        end

        it 'assigns @contact to a new model' do
          post :create, params: params
          expect(assigns(:contact)).to be_a_new(Contact)
        end
      end

      it 'renders :new' do
        post :create, params: params
        expect(response).to have_rendered(:new)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns @contact' do
      get :new
      expect(assigns(:contact)).to be_a_new(Contact)
    end

    it 'renders HTTP status :ok' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'renders HTTP status :ok' do
      get :show
      expect(response).to have_http_status(:ok)
    end
  end
end
