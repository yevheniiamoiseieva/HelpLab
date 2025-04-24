class Message < ApplicationRecord
  belongs_to :request
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :body, presence: true, length: { minimum: 2, maximum: 1000 }

  scope :unread, -> { where(read_at: nil) }
end
