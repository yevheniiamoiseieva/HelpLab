require 'rails_helper'

RSpec.describe ResponsesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:volunteer) { create(:user, :volunteer) }
  let(:request) { create(:request, user: user) }

  describe 'POST #create' do
    context 'when volunteer responds' do
      before { sign_in volunteer }

      it 'creates a new response' do
        expect {
          post :create, params: { request_id: request.id, response: { message: 'I can help' } }
        }.to change(Response, :count).by(1)
      end

      it 'creates associated notification' do
        expect {
          post :create, params: { request_id: request.id, response: { message: 'I can help' } }
        }.to change(Notification, :count).by(1)
      end
    end
  end
end