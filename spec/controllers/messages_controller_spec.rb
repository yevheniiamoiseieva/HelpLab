require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user, :regular) }
  let(:volunteer) { create(:user, :volunteer) }
  let(:request_record) { create(:request, user: user) }
  let(:message) { create(:message, request: request_record, sender: user, receiver: volunteer) }

  before { sign_in(current_user) }


  describe "GET #index" do
    context "when current_user is the request owner" do
      let(:current_user) { user }

      context "and partner_id is present and valid" do
        it "assigns @companion and loads messages" do
          get :index, params: { request_id: request_record.id, partner_id: volunteer.id }

          expect(assigns(:companion)).to eq(volunteer)
          expect(assigns(:messages)).to be_a(ActiveRecord::Relation)
        end
      end

      context "and partner_id is missing" do
        it "assigns empty @messages array" do
          get :index, params: { request_id: request_record.id }

          expect(assigns(:messages)).to eq([])
        end
      end

      context "and partner_id is invalid" do
        it "shows alert and assigns empty @messages" do
          get :index, params: { request_id: request_record.id, partner_id: 0 }

          expect(flash.now[:alert]).to eq("Не знайдено користувача для цього ID.")
          expect(assigns(:messages)).to eq([])
        end
      end
    end

    context "when current_user is not the request owner" do
      let(:current_user) { volunteer }

      it "assigns @companion as request owner and loads messages" do
        get :index, params: { request_id: request_record.id }

        expect(assigns(:companion)).to eq(user)
        expect(assigns(:messages)).to be_a(ActiveRecord::Relation)
      end
    end
  end

  describe "POST #create" do
    let(:current_user) { user }

    context "with valid partner_id and message" do
      it "creates a new message and notification" do
        expect {
          post :create, params: {
            request_id: request_record.id,
            partner_id: volunteer.id,
            message: { body: "Hello!" }
          }
        }.to change(Message, :count).by(1)
                                    .and change(Notification, :count).by(1)

        expect(response).to redirect_to(request_messages_path(request_record, partner_id: volunteer.id))
      end
    end

    context "when partner_id is missing" do
      it "redirects back with an alert" do
        post :create, params: { request_id: request_record.id, message: { body: "Hello!" } }

        expect(flash[:alert]).to eq("ID партнера відсутній.")
        expect(response).to redirect_to(request_messages_path(request_record))
      end
    end

    context "when partner_id is invalid" do
      it "redirects back with an alert" do
        post :create, params: { request_id: request_record.id, partner_id: 0, message: { body: "Hello!" } }

        expect(flash[:alert]).to eq("Не знайдено користувача для цього ID.")
        expect(response).to redirect_to(request_messages_path(request_record))
      end
    end
  end
end
