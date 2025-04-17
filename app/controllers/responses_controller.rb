class ResponsesController < ApplicationController
  before_action :authenticate_user!

  def create
    @request = Request.find(params[:request_id])
    @response = @request.responses.build(user: current_user, status: "Прийнято")

    if @response.save
      # Отправка email автору запроса
      ResponseMailer.notify_request_owner(@response).deliver_later

      # Запись в таблицу Notification
      Notification.create!(
        user: @request.user,
        message: "Вам відгукнувся волонтер на запит '#{@request.title}'",
        request: @request
      )

      redirect_to @request, notice: "Ви відгукнулись."
    else
      redirect_to @request, alert: "Помилка при відгуку."
    end
  end
end
