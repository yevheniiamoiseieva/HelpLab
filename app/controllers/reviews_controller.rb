class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    reviewed_user = User.find(params[:user_id])
    review = reviewed_user.reviews.build(review_params.merge(author: current_user))

    if review.save
      redirect_to public_profile_path(reviewed_user), notice: "Відгук надіслано!"
    else
      redirect_to public_profile_path(reviewed_user), alert: "Помилка при збереженні відгуку."
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
