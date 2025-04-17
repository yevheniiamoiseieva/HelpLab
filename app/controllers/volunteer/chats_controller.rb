module Volunteer
  class ChatsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_volunteer

    def index
      # Список заявок, на которые откликнулся текущий волонтёр
      @chats = Request.joins(:responses)
                      .where(responses: { user_id: current_user.id })
                      .distinct
                      .order(updated_at: :desc)
    end

    def show
      # 1) Находим заявку по ID из params[:id]
      @request = Request.find(params[:id])

      # 2) Проверяем, что текущий волонтёр действительно связан с @request
      unless @request.responses.exists?(user_id: current_user.id)
        redirect_to volunteer_chats_path, alert: "У вас немає доступу до цього чату."
        return  # прерываем выполнение
      end

      # 3) Загружаем связанные сообщения (используем order по created_at)
      @messages = @request.messages.order(:created_at)

      # 4) Определяем партнёра – считаем, что автор заявки является партнёром
      @partner = @request.user
      unless @partner
        flash[:alert] = "ID партнера відсутній"
        redirect_to volunteer_chats_path
      end
    end

    private

    def ensure_volunteer
      # Если роль хранится как "volunteer", проверяем именно это значение
      unless current_user.role == "volunteer"
        redirect_to root_path, alert: "Цей розділ доступний лише волонтерам"
      end
    end
  end
end
