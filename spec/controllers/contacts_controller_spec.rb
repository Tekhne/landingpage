require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe 'GET #create' do
    # TODO
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

    it 'renders :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #show' do
    # TODO
  end
end
