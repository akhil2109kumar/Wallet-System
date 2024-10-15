require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns all users' do
      get :index
      expect(assigns(:users)).to eq([ user ])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { name: 'Alice', email: 'alice@example.com', password: 'password' } }
    let(:invalid_attributes) { { name: '', email: '', password: '' } }

    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'creates a wallet for the user' do
        post :create, params: { user: valid_attributes }
        user = User.last
        expect(user.wallet).to be_present
      end

      it 'returns a created status' do
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.to_not change(User, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) { { name: 'Alice Updated' } }

    context 'with valid attributes' do
      it 'updates the user' do
        put :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(user.name).to eq('Alice Updated')
      end

      it 'returns a successful response' do
        put :update, params: { id: user.id, user: new_attributes }
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the user' do
        put :update, params: { id: user.id, user: { name: '' } }
        user.reload
        expect(user.name).to_not eq('')
      end

      it 'returns an unprocessable entity status' do
        put :update, params: { id: user.id, user: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end

    it 'returns a no content status' do
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
