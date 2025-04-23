# spec/system/requests_flow_spec.rb
require 'rails_helper'


RSpec.describe 'Messaging system', type: :system do
  include Warden::Test::Helpers

  scenario "User creates and manages request" do
    user = create(:user)
    volunteer = create(:user, role: 'volunteer')

    login_as(user, scope: :user)
    visit new_request_path
    fill_in 'Назва', with: 'Ліжко'
    select 'Мебелі', from: 'Категорія'
    fill_in 'Опис', with: 'Потрібне ліжко дитині'
    click_button 'Створити'
    logout(:user)

    login_as(volunteer, scope: :user)
    visit request_path(Request.last)
    click_button 'Хочу допомогти'
    fill_in 'Повідомлення', with: 'Я можу надати ліжко'
    click_button 'Надіслати'
    logout(:user)

    login_as(user, scope: :user)
    visit notifications_path
    expect(page).to have_content('Новий відгук на ваш запит')
  end
end
