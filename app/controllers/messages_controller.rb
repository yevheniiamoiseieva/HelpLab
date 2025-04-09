class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @request = Request.find(params[:request_id])
    @messages = Message.where(request: @request)
                       .where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
                       .order(created_at: :asc)
    @new_message = Message.new

    # 👉 Определяем собеседника
    @companion = @request.user == current_user ? @request.responses.first.user : @request.user
  end

  def create
    @request = Request.find(params[:request_id])
    @message = Message.new(message_params)
    @message.sender = current_user
    @message.receiver = @request.user == current_user ? @request.responses.first.user : @request.user
    @message.request = @request

    if @message.save
      # 💬 Сповіщення для іншої сторони (волонтера або автора запиту)
      Notification.create!(
        user: @message.receiver,
        message: "Нове повідомлення у запиті '#{@request.title}'",
        request: @request
      )

      redirect_to request_messages_path(@request)
    else
      render :index, alert: "Помилка при відправленні повідомлення."
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
