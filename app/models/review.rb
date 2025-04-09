class Review < ApplicationRecord
  belongs_to :reviewed_user, class_name: "User"
  belongs_to :author, class_name: "User"

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true
end
