require 'rails_helper'


RSpec.describe 'Messaging system', type: :system do
  include Devise::Test::IntegrationHelpers

  scenario 'Complete messaging flow' do
    # 1. Пользователь создает запрос
    user = create(:user)
    volunteer = create(:user, :volunteer)
    request = create(:request, user: user)

    # 2. Волонтер отправляет сообщение
    sign_in volunteer
    visit request_path(request)
    fill_in 'message_body', with: 'Я могу помочь с этим'
    click_button 'Отправить'

    # 3. Проверка уведомления
    sign_in user
    visit notifications_path
    expect(page).to have_content('Новое сообщение')
  end
end