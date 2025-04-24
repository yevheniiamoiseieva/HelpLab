require "rails_helper"

RSpec.feature "ProfileShow", type: :feature do
  let(:user) { create(:user, role: "volunteer") }
  let(:profile) { user.profile }
  puts "Capybara host: #{Capybara.app_host}"

  before do
    sign_in user
    visit profile_path
  end

  scenario "User sees their profile information" do
    expect(page).to have_css("h2", text: "Мій профіль")
    expect(page).to have_content(profile.full_name)
    expect(page).to have_content(user.email)
  end

  scenario "User sees rating and reviews if they are a volunteer" do
    # Добавляем отзывы, если нужно
    create(:review, reviewed_user: user, rating: 4)
    visit profile_path

    expect(page).to have_css(".text-yellow-500") # звезды
    expect(page).to have_content("Рейтинг:")
  end

  scenario "User sees the 'Edit' button if it's their profile" do
    expect(page).to have_link("Редагувати", href: edit_profile_path)
  end
end
