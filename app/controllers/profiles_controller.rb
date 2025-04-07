# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def show
  end

  def edit
  end

  def update
    if @profile.update(profile_params)

      redirect_to profile_path, notice: "Profile updated successfully!"
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile || current_user.create_profile(
      first_name: current_user.email.split('@').first
    )
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :location, :bio, :avatar)
  end

end