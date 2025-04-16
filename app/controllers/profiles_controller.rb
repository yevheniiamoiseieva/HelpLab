class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_own_profile, only: [:edit, :update]
  before_action :set_profile_by_id, only: [:show]
  before_action :set_public_profile, only: [:public_show]

  # 👤 Профіль поточного користувача
  def show
  end
  # 🧑‍💻 Публічний перегляд іншого користувача (для чату)
  def public_show
    render :show
    @can_review = current_user != @profile.user && current_user.role != "Волонтер"
    @already_reviewed = @profile.user.reviews.exists?(reviewer_id: current_user.id)


  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Профіль успішно оновлено!"
    else
      render :edit
    end
  end

  private

  # Для редагування свого профілю
  def set_own_profile
    @profile = current_user.profile || current_user.create_profile(
      first_name: current_user.email.split('@').first
    )
  end

  # Для перегляду свого профілю
  def set_profile_by_id
    @profile = current_user.profile
  end

  # Для перегляду чужого профілю (chat → profile)
  def set_public_profile
    user = User.find(params[:id])
    @profile = user.profile || user.create_profile(first_name: user.email.split('@').first)
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :bio, :avatar, :country, :city)
  end
end
