class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @request = Request.find(params[:request_id])
    @new_message = Message.new

    if current_user == @request.user
      # Автор запиту — бачить список волонтерів
      if params[:partner_id].present?
        @companion = User.find_by(id: params[:partner_id])
        if @companion
          load_messages(@companion)
        else
          flash.now[:alert] = "Не знайдено користувача для цього ID."
          @messages = []
        end
      else
        @messages = []
      end
    else
      # Волонтер — автоматично бачить чат з автором запиту
      @companion = @request.user
      load_messages(@companion)
    end
  end

  def create
    @request = Request.find(params[:request_id])

    if params[:partner_id].present?
      @companion = User.find_by(id: params[:partner_id])
      if @companion.nil?
        flash[:alert] = "Не знайдено користувача для цього ID."
        redirect_to request_messages_path(@request) and return
      end
    else
      flash[:alert] = "ID партнера відсутній."
      redirect_to request_messages_path(@request) and return
    end

    @message = Message.new(message_params)
    @message.sender = current_user
    @message.receiver = @companion
    @message.request = @request

    if @message.save
      Notification.create!(
        user: @message.receiver,
        message: "Нове повідомлення у запиті '#{@request.title}'",
        request: @request
      )

      redirect_to request_messages_path(@request, partner_id: @message.receiver.id)
    else
      flash[:alert] = "Помилка при відправленні повідомлення."
      render :index
    end
  end

  private

  def load_messages(companion)
    @messages = Message.where(request: @request)
                       .where(
                         "(sender_id = :user_id AND receiver_id = :companion_id) OR
                          (sender_id = :companion_id AND receiver_id = :user_id)",
                         user_id: current_user.id, companion_id: companion.id
                       )
                       .order(created_at: :asc)
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
