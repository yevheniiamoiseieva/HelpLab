class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :request

  scope :unread, -> { where(read_at: nil) }
end
