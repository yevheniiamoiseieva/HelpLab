class Notification < ApplicationRecord
  belongs_to :request

  belongs_to :user

  scope :unread, -> { where(read_at: nil) }
end
