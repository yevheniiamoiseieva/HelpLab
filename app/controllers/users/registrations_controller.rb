class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :role ])
  end

  # Переопределяем путь после успешной регистрации
  def after_sign_up_path_for(resource)
    root_path
  end

  # Путь для случая, когда регистрация проходит, но аккаунт еще не активирован (например, подтверждение email)
  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  # Переопределяем respond_with, чтобы избежать попыток использовать users_url при ошибках
  def respond_with(resource, _opts = {})
    if resource.persisted?
      redirect_to after_sign_up_path_for(resource)
    else
      render :new
    end
  end
end
