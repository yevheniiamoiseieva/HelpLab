class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[show edit update destroy complete revert]

  def index
    @requests = current_user.requests.order(created_at: :desc)
  end

  def show; end

  def new
    @request = current_user.requests.build
    set_location_if_needed
  end

  def create
    @request = current_user.requests.build(request_params.except(:status))
    @request.status = "потрібна допомога"
    set_location_if_needed

    if @request.save
      redirect_to @request, notice: "Запит створено."
    else
      flash[:alert] = "Ошибка при создании запроса: #{@request.errors.full_messages.join(", ")}"
      render :new
    end
  end

  def edit; end

  def update
    if @request.update(request_params)
      redirect_to @request, notice: "Обновлено."
    else
      flash[:alert] = "Ошибка при обновлении запроса: #{@request.errors.full_messages.join(", ")}"
      render :edit
    end
  end

  def destroy
    @request.destroy
    redirect_to requests_path, notice: "Видалено."
  end

  def complete
    if can_change_status?
      if @request.update(status: "Завершено")
        redirect_to @request, notice: "Запит позначено як завершений"
      else
        redirect_to @request, alert: "Не вдалося оновити статус запиту"
      end
    else
      redirect_to @request, alert: "У вас немає прав завершувати цей запит."
    end
  end


  def revert
    if can_change_status?
      if @request.update(status: "потрібна допомога")
        redirect_to @request, notice: "Статус повернуто на 'потрібна допомога'"
      else
        redirect_to @request, alert: "Не вдалося повернути статус"
      end
    else
      redirect_to @request, alert: "У вас немає прав змінювати статус цього запиту."
    end
  end
  private

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:title, :description, :category, :status, :location)
  end

  def set_location_if_needed
    @request.location ||= [ current_user.profile.city, current_user.profile.country ].compact.join(", ") if current_user.profile.present?
  end

  def can_change_status?
    current_user == @request.user || current_user.role == "волонтер"
  end
end
