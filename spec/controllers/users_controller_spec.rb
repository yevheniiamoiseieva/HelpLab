require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }  # Создаем пользователя для тестов

  describe "GET #index" do
    before do
      sign_in user  # Входим в систему перед тестом
    end

    it "assigns @users and renders the index template" do
      get :index
      expect(assigns(:users)).to eq([ user ])  # Проверка, что @users правильно установлено
      expect(response).to render_template(:index)  # Проверка, что рендерится правильный шаблон
    end
  end

  describe "GET #show" do
    context "when viewing their own profile" do
      before do
        sign_in user
      end

      it "assigns @user and renders the show template" do
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
        expect(response).to render_template(:show)
      end
    end

    context "when viewing another user's profile" do
      let(:other_user) { create(:user) }

      before do
        sign_in user
      end

      it "assigns @users and renders the index template" do
        get :index
        expect(assigns(:users)).to include(user)  # Check if the collection includes our test user
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET #show when not signed in" do
    it "redirects to the sign-in page" do
      get :show, params: { id: user.id }
      expect(response).to redirect_to(new_user_session_path)  # Проверка редиректа на страницу входа
    end
  end
end
