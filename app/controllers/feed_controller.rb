

class FeedController < ApplicationController
  before_action :authenticate_user!, except: [:index, :about]

  def index
    if current_user
      if current_user.volunteer?
        @requests = RequestsQuery.new(Request.where.not(user_id: current_user.id))
                                 .call(filter_params)
                                 .includes(:user, :responses)
      else
        @user_requests = RequestsQuery.new(current_user.requests)
                                      .call(filter_params)
                                      .includes(:responses, :messages)

        @completed_requests = current_user.requests
                                          .recently_completed
                                          .includes(responses: :user)
                                          .where.not(responses: { id: nil })
                                          .distinct
      end

      load_volunteers_for_map
    end

    @contacts = ["https://dopomoga.gov.ua", "https://pryhulky.com", "https://help.gov.ua"]
    @news = [
      "З 1 травня змінилась адресна допомога ВПО",
      "Нові пункти обігріву у Харкові",
      "Пільги для оренди житла для переселенців"
    ]
  end

  def about
    @team_members = [
      { name: "Іван Петренко", role: "Розробник" },
      { name: "Олена Сидорова", role: "Дизайнер" },
      { name: "Михайло Іванов", role: "Координатор" }
    ]
    @mission = "Наша місія - об'єднати тих, хто потребує допомоги, з тими, хто готовий допомагати."
  end

  def become_volunteer
    if current_user
      current_user.update(role: 'volunteer')
      redirect_to root_path, notice: 'Вітаємо! Тепер ви волонтер.'
    else
      redirect_to new_user_registration_path, alert: 'Будь ласка, спочатку зареєструйтесь.'
    end
  end

  private
  def filter_params
    params.permit(:category, :status, :location, :search, :sort)
  end

  def load_volunteers_for_map
    return unless current_user.profile&.city.present?

    @volunteers = User.volunteers
                      .joins(:profile)
                      .where.not(profiles: { city: nil })
                      .where(profiles: { city: current_user.profile.city })
                      .select('users.*, profiles.first_name, profiles.city, profiles.country')
                      .limit(50)
                      .map do |u|
      {
        id: u.id,
        name: u.profile.first_name,
        city: u.profile.city,
        country: u.profile.country,
        avatar_url: u.profile.avatar.attached? ? url_for(u.profile.avatar) : nil
      }
    end

    Rails.logger.debug "Volunteers for map: #{@volunteers.inspect}"
  end
end