require 'rails_helper'


RSpec.describe 'Messaging system', type: :system do
  include Devise::Test::IntegrationHelpers

  scenario 'Complete volunteer workflow' do
    # 1. Регистрация нового волонтера
    visit new_user_registration_path
    fill_in 'Email', with: 'new_volunteer@example.com'
    fill_in 'Пароль', with: 'password123'
    fill_in 'Підтвердження пароля', with: 'password123'
    click_button 'Зареєструватися'

    # 2. Стать волонтером
    click_link 'Стати волонтером'
    expect(page).to have_content('Тепер ви волонтер')

    # 3. Просмотр и отклик на запрос
    request = create(:request, title: 'Потрібна їжа')
    visit requests_path
    click_link 'Потрібна їжа'
    click_button 'Хочу допомогти'
    fill_in 'Повідомлення', with: 'Можу надати продукти'
    click_button 'Надіслати'

    # 4. Проверка чата
    expect(page).to have_content('Можу надати продукти')
  end
end