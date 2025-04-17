class FeedController < ApplicationController
  before_action :authenticate_user!, except: [:index, :about]

  def index
    @contacts = ["https://dopomoga.gov.ua", "https://pryhulky.com", "https://help.gov.ua"]
    @news = [
      "З 1 травня змінилась адресна допомога ВПО",
      "Нові пункти обігріву у Харкові",
      "Пільги для оренди житла для переселенців"
    ]

    return unless current_user

    if current_user.volunteer?
      load_volunteer_requests
    else
      load_user_requests
    end

    load_volunteers_for_map
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
      flash[:alert] = 'Будь ласка, спочатку зареєструйтесь.'  # Устанавливаем собственное сообщение
      redirect_to new_user_session_path
    end
  end

  private

  # Фильтры для запроса
  def filter_params
    params.permit(:category, :status, :location, :search, :sort)
  end

  # Логика для загрузки запросов волонтера
  def load_volunteer_requests
    @requests = RequestsQuery.new(Request.where.not(user_id: current_user.id))
                             .call(filter_params)
                             .includes(:user, :responses)
  end

  # Логика для загрузки запросов обычного пользователя
  def load_user_requests
    @user_requests = RequestsQuery.new(current_user.requests)
                                  .call(filter_params)
                                  .includes(:responses, :messages)

    # Все завершенные запросы пользователя, отсортированные по дате обновления
    @completed_requests = current_user.requests
                                      .where(status: 'Завершено')
                                      .order(updated_at: :desc)
                                      .includes(responses: :user)
  end

  # Загрузка волонтёров для отображения на карте
  def load_volunteers_for_map
    if current_user.profile&.city.present?
      @volunteers = User.volunteers
                        .joins(:profile)
                        .where(profiles: { city: current_user.profile.city })
                        .select('users.*, profiles.first_name, profiles.city, profiles.country')
                        .limit(50)
                        .map { |user| map_volunteer(user) }
    else
      @volunteers = []
    end

    Rails.logger.debug "Volunteers for map: #{@volunteers.inspect}" if Rails.env.development?
  end

  # Преобразование данных волонтера для карты
  def map_volunteer(user)
    {
      id: user.id,
      name: user.profile.first_name,
      city: user.profile.city,
      country: user.profile.country,
      avatar_url: user.profile.avatar.attached? ? url_for(user.profile.avatar) : nil
    }
  end
end
