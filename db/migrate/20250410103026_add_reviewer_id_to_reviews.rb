class AddReviewerIdToReviews < ActiveRecord::Migration[7.2]
  def change
    add_column :reviews, :reviewer_id, :integer
  end
end
