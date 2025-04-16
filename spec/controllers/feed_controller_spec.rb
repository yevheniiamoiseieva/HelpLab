require 'rails_helper'

RSpec.describe FeedController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe '#about' do
    it 'assigns @team_members and @mission' do
      get :about

      expect(assigns(:team_members)).to eq([
                                             { name: "Іван Петренко", role: "Розробник" },
                                             { name: "Олена Сидорова", role: "Дизайнер" },
                                             { name: "Михайло Іванов", role: "Координатор" }
                                           ])

      expect(assigns(:mission)).to eq("Наша місія - об'єднати тих, хто потребує допомоги, з тими, хто готовий допомагати.")
    end
  end

  describe '#index' do
    context 'when user is not signed in' do
      it 'does not assign @requests or @user_requests' do
        get :index
        expect(assigns(:requests)).to be_nil
        expect(assigns(:user_requests)).to be_nil
      end

      it 'assigns @contacts and @news' do
        get :index
        expect(assigns(:contacts)).to include("https://dopomoga.gov.ua")
        expect(assigns(:news)).to include("З 1 травня змінилась адресна допомога ВПО")
      end
    end

    context 'when current_user is a volunteer' do
      let(:user) { create(:user, :volunteer, confirmed_at: Time.current) }

      before { sign_in user }

      it 'calls load_volunteer_requests' do
        expect(controller).to receive(:load_volunteer_requests).and_call_original
        allow(controller).to receive(:load_volunteers_for_map).and_return([])
        get :index
      end
    end

    context 'when current_user is a regular user' do
      let(:user) { create(:user, :regular, confirmed_at: Time.current) }

      before { sign_in user }

      it 'calls load_user_requests' do
        expect(controller).to receive(:load_user_requests).and_call_original
        allow(controller).to receive(:load_volunteers_for_map).and_return([])
        get :index
      end
    end
  end

  describe '#become_volunteer' do
    context 'when user is signed in' do
      let(:user) { create(:user, :regular, confirmed_at: Time.current) }

      before { sign_in user }

      it 'updates the user role to volunteer' do
        post :become_volunteer
        user.reload
        expect(user.role).to eq('volunteer')
      end

      it 'redirects to root path with notice' do
        post :become_volunteer
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Вітаємо! Тепер ви волонтер.')
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in path with alert' do
        post :become_volunteer
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.') # Проверяем сообщение Devise
      end
    end
  end
end
